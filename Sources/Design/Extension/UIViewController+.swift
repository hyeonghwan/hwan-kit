

#if canImport(UIKit)
import UIKit

public extension UIViewController {
    var windowWidth: CGFloat {
        view.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    var windowHeight: CGFloat {
        view.window?.windowScene?.screen.bounds.height ?? UIScreen.main.bounds.height
    }
}

#endif
