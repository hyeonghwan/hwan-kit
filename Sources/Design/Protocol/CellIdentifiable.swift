#if canImport(UIKit)

import UIKit

public protocol CellIdentifialble {
    static var id: String { get }
}

public extension CellIdentifialble {
    static var id: String {
        String(describing: Self.self)
    }
}

#endif
