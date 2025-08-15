//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation

public enum NetworkError: Error {
    case transport(Error)               // 네트워크 계층
    case invalidURL(String)
    case invalidResponse                // URLResponse 캐스팅 실패 등
    case unacceptableStatus(Int, Data?) // 2xx 외 상태
    case decoding(Error, Data)          // 디코딩 실패
}
