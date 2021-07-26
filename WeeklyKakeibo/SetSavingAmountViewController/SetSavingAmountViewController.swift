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
    
    @IBOutlet weak var descriptionView: UIView! {
        didSet {
            descriptionView.layer.cornerRadius = 10.0
            descriptionView.clipsToBounds = true
        }
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
    private let globalVar = GlobalVar.shared
    private var texts: [String] = []
    
    override func loadView() {
        if let view = UINib(nibName: "SetSavingAmountViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
        self.view = view
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        
        notificationCenter.addObserver(self, selector: #selector(backToView), name: .okButtonTapped, object: nil)
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    private func skipButtonTapped() {
        self.backToView()
    }
    
    private func okButtonTapped() {
        setUserDefaults()
    }

    private func setTextFields() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        for amount in globalVar.amounts {
            guard let data = UserDefaults.standard.data(forKey: amount),
                let decodedData = try? jsonDecoder.decode(Amount.self, from: data) else {
                continue
            }
            texts.append(String(decodedData.value))
        }
        
        let textFields = [incomeTextField,
                          savingsTextField,
                          rentTextField,
                          utilityTextField,
                          netTextField,
                          waterTextField,
                          otherTextField,
                          otherTextField2]
        for (index, textField) in textFields.enumerated() {
            guard texts.indices.contains(index) else {
                continue
            }
            textField?.text = texts[index]
        }
    }
    
    private func setUserDefaults() {
        guard !(incomeTextField.text ?? "").isEmpty else {
            alert(message: "手取りが未入力です")
            return
        }
        var amounts: [String:Amount] = [:]
         
        let income = Amount(name: "手取り", value: incomeTextField.textToInt)
        let savings = Amount(name: "貯金額", value: savingsTextField.textToInt)
        let rent = Amount(name: "家賃", value: rentTextField.textToInt)
        let utility = Amount(name: "光熱費", value: utilityTextField.textToInt)
        let water = Amount(name: "水道代", value: waterTextField.textToInt)
        let internet = Amount(name: "スマホ・ネット代", value: netTextField.textToInt)
        let other1 = Amount(name: "その他①", value: otherTextField.textToInt)
        let other2 = Amount(name: "その他②", value: otherTextField2.textToInt)
        
        amounts[Constants.Amount.income.rawValue] = income
        amounts[Constants.Amount.savings.rawValue] = savings
        amounts[Constants.Amount.rent.rawValue] = rent
        amounts[Constants.Amount.utility.rawValue] = utility
        amounts[Constants.Amount.water.rawValue] = water
        amounts[Constants.Amount.internet.rawValue] = internet
        amounts[Constants.Amount.other1.rawValue] = other1
        amounts[Constants.Amount.other2.rawValue] = other2
        
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
        self.navigationController?.popViewController(animated: true)
        notificationCenter.post(name: .showKakeiboView, object: nil)
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
