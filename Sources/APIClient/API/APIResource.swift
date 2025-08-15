//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation

public protocol APIResource {
    associatedtype ResponseType: Decodable
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: Query? { get }
    var body: Data? { get }
}

public extension APIResource {
    var scheme: String { "https" }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var query: Query? { nil }

    func urlRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        guard let url = components.url else { throw URLError(.badURL) }

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.allHTTPHeaderFields = headers
        req.httpBody = body
        return req
    }
}

//1.    의사결정은 정책이 하고, 실행은 CoreNetwork가 한다.
//2.    우선순위 트리로 분기 수를 고정한다. (401→토큰, 그 외 재시도/포기)
//3.    멱등성과 요청 메서드에 따라 재시도 허용 범위를 다르게 한다.
//4.    백오프 + 최대시도 + 취소전파로 안전장치.


// 401 Unauthorized refreshAndRetry 토큰 갱신 성공 시 동일 요청 1회 재시도. 실패면 doNotRetry (상위에 “다시 로그인” 이벤트 전달)
// 403 Forbidden doNotRetry 권한 자체가 없음(토큰 만료 아님)
// 429 Too Many Requests retry(after:) Retry-After 헤더 우선, 없으면 지수 백오프(+지터)
// 5xx (서버 오류) retry(after:) 멱등 메서드만(보통 GET/HEAD/PUT) 1~3회 백오프 재시도
// 408 / 네트워크 단절(URLError.notConnectedToInternet, timedOut, networkConnectionLost) retry(after:) 멱등 메서드만, 짧은 백오프
// 클라이언트 4xx(400/404 등) & 디코딩 오류 doNotRetry 요청/스키마 문제는 재시도 무의미
// 취소됨(URLError.cancelled) doNotRetry 즉시 중단
