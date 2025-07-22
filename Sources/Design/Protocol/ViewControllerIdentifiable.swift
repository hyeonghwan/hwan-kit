#if canImport(UIKit)

import UIKit

public protocol ViewControllerIdentifiable {
    static var id: String { get }
}

public extension ViewControllerIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }
}

#endif
