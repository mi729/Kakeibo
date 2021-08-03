//
//  CustomUITextField.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/08/03.
//  
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
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
        self.setUnderLine()

        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeButtonTapped))
        tools.items = [spacer, closeButton]
        self.inputAccessoryView = tools
    }
    
    @objc func closeButtonTapped(){
        self.endEditing(true)
        self.resignFirstResponder()
    }
}
