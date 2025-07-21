
#if canImport(UIKit)
import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        addChild()
        addAttributes()
        addLayout()
        binding()
    }
    open func addChild() { }
    open func addAttributes() { }
    open func addLayout() { }
    open func binding() { }
}

#endif
