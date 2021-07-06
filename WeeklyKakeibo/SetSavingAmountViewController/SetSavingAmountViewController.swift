//
//  SetSavingAmountViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/28.
//  
//

import UIKit
import RealmSwift

class SetSavingAmountViewController: UIViewController {
    @IBAction func skipButton(_ sender: Any) {
        skipButtonTapped()
    }
    
    @IBAction func okButton(_ sender: Any) {
        okButtonTapped()
    }
    
    @IBOutlet weak var incomeTextField: UITextField!
    
    @IBOutlet weak var savingsTextField: UITextField!
    
    @IBOutlet weak var rentTextField: UITextField!
    
    @IBOutlet weak var utilityTextField: UITextField!
    
    
    @IBOutlet weak var netTextField: UITextField!
    
    @IBOutlet weak var waterTextField: UITextField!
    
    @IBOutlet weak var otherTextField: UITextField!
    
    @IBOutlet weak var otherTextField2: UITextField!
    
    @IBOutlet weak var skipButton: CustomButton! {
        didSet {
            skipButton.backgroundColor = .systemGray2
        }
    }

    @IBOutlet weak var okButton: CustomButton!
    
    let notificationCenter = NotificationCenter.default
    private let STORED_KEY = "launched"
    
    override func loadView() {
        if let view = UINib(nibName: "SetSavingAmountViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
        self.view = view
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        notificationCenter.addObserver(self, selector: #selector(backToView), name: .okButtonTapped, object: nil)
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    private func skipButtonTapped() {
        self.backToView()
        self.logFirstLaunch()
    }
    
    private func okButtonTapped() {
        setCosts()
        self.logFirstLaunch()
    }
    
    private func logFirstLaunch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
    private func setCosts() {
        guard !(incomeTextField.text ?? "").isEmpty else {
            alert(message: "手取りが未入力です")
            return
        }
        var amounts: [String:Amount] = [:]
         
        let income = Amount(name: "手取り", amount: incomeTextField.textToInt)
        let savings = Amount(name: "貯金額", amount: savingsTextField.textToInt)
        let rent = Amount(name: "家賃", amount: rentTextField.textToInt)
        let utility = Amount(name: "光熱費", amount: utilityTextField.textToInt)
        let water = Amount(name: "水道代", amount: waterTextField.textToInt)
        let internet = Amount(name: "スマホ・ネット代", amount: netTextField.textToInt)
        let other1 = Amount(name: "その他①", amount: otherTextField.textToInt)
        let other2 = Amount(name: "その他②", amount: otherTextField2.textToInt)
        
        amounts["income"] = income
        amounts["savings"] = savings
        amounts["rent"] = rent
        amounts["utility"] = utility
        amounts["water"] = water
        amounts["internet"] = internet
        amounts["other1"] = other1
        amounts["other2"] = other2
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        for amount in amounts {
            guard let data = try? jsonEncoder.encode(amount.value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: amount.key)
        }
        alert()
    }

    private func alert(message: String) {
        let dialog = UIAlertController(title: "",message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(action)
        
        present(dialog, animated: true, completion: nil)
    }
    
    private func alert() {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let alertViewController = storyboard.instantiateViewController(identifier: "alert")
        alertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func backToView() {
        self.navigationController?.popToRootViewController(animated: true)
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
