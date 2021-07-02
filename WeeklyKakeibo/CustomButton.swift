//
//  CustomButton.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/27.
//  
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
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

    private func setupAttributes() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = #colorLiteral(red: 0.3445842266, green: 0.7374812961, blue: 0.7090910673, alpha: 1)
        self.layer.cornerRadius = 10.0
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
    }
}
