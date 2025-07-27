//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 7/27/25.
//

#if canImport(UIKit)
import UIKit

open class BaseReusableView: UICollectionReusableView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addChild()
        addAttributes()
        addLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAttributes()
    }
    
    open func addChild() { }
    open func addAttributes() { }
    open func addLayout() { }
}

open class BaseTableHeaderFooterView: UITableViewHeaderFooterView {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addChild()
        addAttributes()
        addLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAttributes()
    }
    
    open func addChild() { }
    open func addAttributes() { }
    open func addLayout() { }
}


#endif



