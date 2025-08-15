//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation


protocol ClientWithAsync {
    func execute<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                        decodeType: DTO.Type,
                                                        using profile: SessionType,
                                                        decoder: JSONDecoder?) async -> Result<DTO, any Error>
}

extension ClientWithAsync {
    func execute<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                        decodeType: DTO.Type,
                                                        using profile: SessionType = .default,
                                                        decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        await self.execute(resource: resource, decodeType: decodeType, using: profile, decoder: decoder)
    }
}

protocol ClientWithCallBack {
    func execute<Resource: APIResource, DTO: Decodable & Sendable>(resource: Resource,
                                                                   decodeType: DTO.Type,
                                                                   using profile: SessionType,
                                                                   decoder: JSONDecoder?,
                                                                   completion: @escaping @Sendable (Result<DTO, Error>) -> Void)
}

extension ClientWithCallBack {
    func execute<Resource: APIResource, DTO: Decodable & Sendable>(resource: Resource,
                                                                   decodeType: DTO.Type,
                                                                   using profile: SessionType = .default,
                                                                   decoder: JSONDecoder? = nil,
                                                                   completion: @escaping @Sendable (Result<DTO, Error>) -> Void)
    {
        self.execute(resource: resource, decodeType: decodeType, using: profile, decoder: decoder, completion: completion)
    }
}


#if canImport(Combine)
import Combine
protocol ClientWithCombine {
    func execute<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                        decodeType: DTO.Type,
                                                        using profile: SessionType,
                                                        decoder: JSONDecoder?) -> AnyPublisher<DTO, Error>
}

extension ClientWithCombine {
    func execute<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                        decodeType: DTO.Type,
                                                        using profile: SessionType = .default,
                                                        decoder: JSONDecoder? = nil) -> AnyPublisher<DTO, Error>
    {
        self.execute(resource: resource, decodeType: decodeType, using: profile, decoder: decoder)
    }
}
#endif
