//
//  CustomLabel.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/18.
//  
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        setupAttributes()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAttributes()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupAttributes()
    }

    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: padding)
        super.drawText(in: newRect)
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentSize = super.sizeThatFits(size)
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }


    private func setupAttributes() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.font = UIFont.systemFont(ofSize: 18.0)
    }
}
