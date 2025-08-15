//
//  AnyObserver.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

public final class AnyObserver<Element: Sendable>: ObserverType {
    public var id: UUID = UUID()
    public var handler: ((Event<Element>) -> Void)?
    
    public init(handler: (@escaping (Event<Element>) -> Void)) {
        self.handler = handler
    }
    
    public func receive(_ element: Event<Element>) {
        self.handler?(element)
    }
}
