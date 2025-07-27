//
//  File.swift
//  hwan-kit
//
//  Created by hwan on 7/27/25.
//

#if canImport(UIKit)
import UIKit

open class BaseTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addAttributes()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addAttributes()
    }
    
    open func addAttributes() { }
}

#endif


