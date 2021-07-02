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
    private let STORED_KEY = "lanched"
    
    override func loadView() {
        if let view = UINib(nibName: "SetSavingAmountView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
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
        self.logFirstLanch()
    }
    
    private func okButtonTapped() {
        setCosts()
        self.logFirstLanch()
    }
    
    private func logFirstLanch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
    private func setCosts() {
        let money = Money()
        guard !(incomeTextField.text ?? "").isEmpty else {
        alert(message: "手取りが未入力です")
            return
        }
        money.income = Int(incomeTextField.text!)!
        money.savings = Int(savingsTextField.text ?? "") ?? 0
        money.rent = Int(rentTextField.text ?? "") ?? 0
        money.utility = Int(utilityTextField.text ?? "") ?? 0
        money.water = Int(waterTextField.text ?? "") ?? 0
        money.internet = Int(netTextField.text ?? "") ?? 0
        money.other1 = Int(otherTextField.text ?? "") ?? 0
        money.other2 = Int(otherTextField.text ?? "") ?? 0

        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(money)
                print("item saved")
                alert()
            })
        }catch {
            print("save failed")
        }
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
