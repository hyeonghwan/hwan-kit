
#if canImport(UIKit)
import UIKit

public extension UIView {
    var windowWidth: CGFloat {
        self.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    var windowHeight: CGFloat {
        self.window?.windowScene?.screen.bounds.height ?? UIScreen.main.bounds.height
    }
    
    func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let customView = nibs?.first as? UIView else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
}
#endif

