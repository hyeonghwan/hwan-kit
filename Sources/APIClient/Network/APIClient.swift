//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation

typealias APIClient = ClientWithAsync & ClientWithCallBack & ClientWithCombine

#if canImport(Alamofire)
import Alamofire
#endif

#if canImport(Combine)
import Combine
#endif

public final class DefaultAPIClient: APIClient {
    private let defaultDecoder: JSONDecoder
    private var registry: AFSessionRegistry
    private var encoder: URLQueryEncoder
    
    public init(registry: AFSessionRegistry,
                decoder: JSONDecoder = .init(),
                encoder: URLQueryEncoder = .init())
    {
        self.defaultDecoder = decoder
        self.registry = registry
        self.encoder = encoder
    }
    
    @inline(__always)
    private func appendingQuery<T: Query>(to request: URLRequest,
                                          query: T,
                                          using encoder: URLQueryEncoder) throws -> URLRequest
    {
        guard let baseURL = request.url,
              var comps = URLComponents(
                url: baseURL,
                resolvingAgainstBaseURL: false
              )
        else { throw URLError(.badURL) }
        
        let items = try encoder.encode(query)
        if !items.isEmpty {
            comps.queryItems = (comps.queryItems ?? []) + items
        }
        guard let url = comps.url else { throw URLError(.badURL) }
        var request = request
        request.url = url
        return request
    }
    
    public func execute<Resource: APIResource, DTO: Decodable & Sendable>(
        resource: Resource,
        decodeType: DTO.Type,
        using profile: SessionType = .default,
        decoder: JSONDecoder? = nil,
        completion: @escaping @Sendable (
            Result<DTO, Error>
        ) -> Void
    )
    {
        do {
            let urlRequest = try resource.urlRequest()
            let session = registry.session(for: profile)
            
            session.request(urlRequest, interceptor: .retryPolicy)
                .validate(statusCode: 200..<300)
                .responseDecodable(
                    of: DTO.self,
                    decoder: decoder ?? defaultDecoder
                ) { result in
                    switch result.result {
                    case let .success(dto):
                        completion(.success(dto))
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    public func execute<Resource: APIResource, DTO: Decodable & Sendable>(resource: Resource,
                                                                          decodeType: DTO.Type,
                                                                          using profile: SessionType = .default,
                                                                          decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        do {
            let req = try resource.urlRequest()
            let session = registry.session(for: profile)
            
            let dataTask = session.request(req, interceptor: .retryPolicy)
                .validate(statusCode: 200..<300)
                .serializingDecodable(
                    DTO.self,
                    decoder: decoder ?? self.defaultDecoder
                )
            
            let value = try await dataTask.value
            return .success(value)
        } catch {
            return .failure(error)
        }
    }
    
    @preconcurrency
    public func execute<Resource: APIResource, DTO: Decodable & Sendable>(resource: Resource,
                                                                          decodeType: DTO.Type,
                                                                          using profile: SessionType = .default,
                                                                          decoder: JSONDecoder? = nil) -> AnyPublisher<DTO, any Error>
    {
        var dataRequest: DataRequest?
        
        return Deferred { [weak self] in
            Future<DTO, any Error> { promise in
                do {
                    guard let self else {
                        return
                    }
                    var urlRequest = try resource.urlRequest()
                    if let query = resource.query {
                        urlRequest = try self
                            .appendingQuery(
                                to: urlRequest,
                                query: query,
                                using: self.encoder
                            )
                    }
                    let session = self.registry.session(for: profile)
                    let decoder = decoder ?? self.defaultDecoder
                    
                    let request = session.request(
                        urlRequest,
                        interceptor: .retryPolicy
                    )
                        .validate(statusCode: 200..<300)
                        .responseDecodable(
                            of: DTO.self,
                            decoder: decoder
                        ) { result in
                            switch result.result {
                            case .success(let dto):
                                promise(.success(dto))
                            case .failure(let error):
                                promise(.failure(error))
                            }
                        }
                    
                    dataRequest = request
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveCancel: { dataRequest?.cancel() })
        .eraseToAnyPublisher()
    }
}
