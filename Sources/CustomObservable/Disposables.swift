//
//  Disposables.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

public protocol Disposables {
    var id: UUID? { get }
    
    /// do not Call this method directly
    /// - Parameter id: Observer ID
    func dispose(id: UUID)
    
    func disposed(in bag: Bag)
}

public struct DefaultDisposables: Hashable, Equatable, Disposables {
    public var id: UUID?
    let disposables: Disposables
    
    public static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public func dispose() {
        self.disposables.dispose(id: self.id!)
    }
    
    public func dispose(id: UUID) {
        self.disposables.dispose(id: id)
    }
    
    public func disposed(in bag: Bag) {
        bag.insert(self)
    }
}


public final class Bag {
    var subscriptions = Set<DefaultDisposables>()
    var isDisposed: Bool = false
    
    public init(subscriptions: Set<DefaultDisposables> = Set<DefaultDisposables>()) {
        self.subscriptions = subscriptions
    }
    
    func insert(_ disposables: DefaultDisposables) {
        if isDisposed {
            disposables.dispose()
        } else {
            subscriptions.insert(disposables)
        }
    }
    
    public func dispose() {
        self.isDisposed = true
        for subscription in subscriptions {
            subscription.dispose()
        }
    }
    
    deinit { dispose() }
}

