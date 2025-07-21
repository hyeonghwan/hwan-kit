#if canImport(UIKit)

import UIKit

protocol VCIdentifiable {
    static var id: String { get }
}

extension VCIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }
}

#endif
