//
//  Event.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


public enum Event<Element: Sendable> {
    case next(Element)
    case completed
    case error(Error)
}
