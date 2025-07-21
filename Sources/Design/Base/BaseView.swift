

#if canImport(UIKit)
import UIKit

@MainActor
open class BaseView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addChild()
        addAttributes()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAttributes()
    }
    
    open func addChild() { }
    open func addAttributes() { }
}

#endif
