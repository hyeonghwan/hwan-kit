//
//  BaseObservable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

public class BaseObservable<Element: Sendable>: ObservableType, Disposables {
    public var id: UUID?
    
    public func disposed(in bag: Bag) { }
    
    var observers = [AnyObserver<Element>]()
    
    var isDisposed: Bool = false
    
    func on(_ element: Element) {
        for observer in observers {
            observer.receive(.next(element))
        }
    }
    
    func onError(_ error: Error) {
        for observer in observers {
            observer.receive(.error(error))
        }
    }
    
    func onCompleted() {
        for observer in observers {
            observer.receive(.completed)
        }
    }
    
    public func subscribe(_ observer: AnyObserver<Element>) -> Disposables {
        self.observers.append(observer)
        return DefaultDisposables(
            id: observer.id,
            disposables: self
        )
    }
    
    public func subscribeOn(
        onNext: @escaping (Element) -> Void,
        onError: @escaping (Error) -> Void = { _ in },
        completed: @escaping () -> Void = { }
    ) -> Disposables
    {
        let observer = AnyObserver<Element>.init(handler: { [weak self] event in
            switch event {
            case .completed:
                completed()
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .error(error):
                onError(error)
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .next(element):
                onNext(element)
            }
        })
        return subscribe(observer)
    }

    
    public func subscribeAsync(
        onNext: @escaping @Sendable (Element) async -> Void,
        onError: @escaping (Error) -> Void = { _ in },
        completed: @escaping () -> Void = { }
    ) -> Disposables
    {
        let observer = AnyObserver<Element>.init(handler: { [weak self] event in
            switch event {
            case .completed:
                completed()
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .error(error):
                onError(error)
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .next(element):
                Task {
                    await onNext(element)
                }
            }
        })
        return subscribe(observer)
    }
    
    public func dispose() {
        self.observers.removeAll()
        self.isDisposed = true
    }
    
    public func dispose(id: UUID) {
        if let index = self.observers.firstIndex(where: { observer in observer.id == id }) {
            print("self.observers: \(self.observers[index])")
            self.observers.remove(at: index)
        }
    }
}
