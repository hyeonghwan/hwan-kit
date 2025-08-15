//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 8/15/25.
//

import Foundation

#if canImport(Alamofire)
import Alamofire
public protocol SessionRegistry {
    /**
     MARK: DefaultSessionRegistry 처럼 생성해서 CoreNetwork에 주입
     
    - 필요한 URLConfiguration을 설정하여 URLsession을 저장하는 Registry
     
     kind에 해당하는 URLSession을 반환
     **/
    func session(for kind: SessionType) -> Session
}

public final class AFSessionRegistry: SessionRegistry {
    private var store: [SessionType: Session] = [:]
    private let lock = NSLock()
    private let monitor: EventMonitor?
    
    init(monitor: EventMonitor) {
        self.monitor = monitor
    }
    
    public func session(for kind: SessionType) -> Session {
        lock.lock()
        
        defer {
            lock.unlock()
        }
        
        if let session = store[kind] {
            return session
        }
        
        let session = makeSession(kind)
        store[kind] = session
        
        return session
    }
    
    private func makeSession(_ profile: SessionType) -> Session {
        switch profile {
        case .default:
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 15
            return Session(configuration: configuration, eventMonitors: monitor == nil ? [] : [monitor!])
            
        case .ephemeral:
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpShouldSetCookies = false
            return Session(configuration: configuration, eventMonitors: monitor == nil ? [] : [monitor!])
        }
    }
}
#endif
