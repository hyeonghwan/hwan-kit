#if canImport(UIKit)

import UIKit

protocol ViewControllerIdentifiable {
    static var id: String { get }
}

extension ViewControllerIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }
}

#endif
