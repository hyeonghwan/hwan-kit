//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation

public final class URLQueryEncoder {
    private let encoder: JSONEncoder
    
    public init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let data = try encoder.encode(value)
        let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        return flatten(obj).map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
    }
    
    private func flatten(_ dict: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        for (key, value) in dict {
            result[key] = value
        }
        return result
    }
}
