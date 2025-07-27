//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 7/27/25.
//

#if canImport(UIKit)
import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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



