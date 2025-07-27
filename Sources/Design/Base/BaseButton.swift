//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 7/27/25.
//

#if canImport(UIKit)
import UIKit

open class BaseButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addAttributes()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAttributes()
    }
    
    open func addAttributes() { }
}

#endif
