//
//  CustomButton.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/27.
//  
//

import UIKit

class CustomButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor {_ in return #colorLiteral(red: 0.3445842266, green: 0.7374812961, blue: 0.7090910673, alpha: 1)}
        self.layer.cornerRadius = 10.0
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
}
