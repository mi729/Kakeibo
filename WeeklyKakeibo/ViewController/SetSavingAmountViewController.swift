//
//  SetSavingAmountViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/28.
//  
//

import UIKit

class SetSavingAmountViewController: UIViewController {
    @IBAction func skipButton(_ sender: Any) {
        skipButtonTapped()
    }
    
    @IBAction func okButton(_ sender: Any) {
        okButtonTapped()
    }
    
    @IBOutlet weak var incomeTextField: UITextField!
    
    @IBOutlet weak var rentTextField: UITextField!
    
    @IBOutlet weak var utilityTextField: UITextField!
    
    
    @IBOutlet weak var netTextField: UITextField!
    
    @IBOutlet weak var waterTextField: UITextField!
    
    @IBOutlet weak var otherTextField: UITextField!
    
    @IBOutlet weak var otherTextField2: UITextField!
    
    let notificationCenter = NotificationCenter.default
    private let STORED_KEY = "lanched"
    
    override func loadView() {
        if let view = UINib(nibName: "SetSavingAmountView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
        self.view = view
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradient(view: view)
        incomeTextField.delegate = self
        rentTextField.delegate = self
        utilityTextField.delegate = self
        netTextField.delegate = self
        waterTextField.delegate = self
        otherTextField.delegate = self
        otherTextField2.delegate = self
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
    }
    
    func setGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 88/256.0, green: 188/256.0, blue: 181/256.0, alpha: 1).cgColor
        let color2 = UIColor.white
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5 , y:1 )
        view.layer.insertSublayer(gradientLayer,at:0)
    }
    
    func skipButtonTapped() {
        let vc = ViewController()
        self.navigationController?.popToViewController(vc, animated: true)
        self.logFirstLanch()
    }
    
    func okButtonTapped() {
        self.logFirstLanch()
    }
    
    func logFirstLanch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension SetSavingAmountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
