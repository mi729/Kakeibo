//
//  InputViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/14.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    @IBOutlet weak var weekLabel: UILabel! {
        didSet {
            weekLabel.text = "週"
        }
    }
    
    @IBOutlet weak var naiyouLabel: UILabel! {
        didSet {
            naiyouLabel.text = "内容"
        }
    }
    
    @IBOutlet weak var costLabel: UILabel! {
        didSet {
            costLabel.text = "金額"
        }
    }
    @IBOutlet weak var costTextField: DoneTextFierd! {
        didSet {
            costTextField.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var titleTextField: DoneTextFierd!
    
    @IBOutlet weak var cancelButton: CustomButton! {
        didSet {
            cancelButton.setTitle("キャンセル", for: .normal)
            cancelButton.backgroundColor = .systemGray2
        }
    }

    @IBOutlet weak var addButton: CustomButton! {
        didSet {
            addButton.setTitle("追加する", for: .normal)
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        addItem()
    }
    
    
    let inputViewModel = InputViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }

    private func addItem() {
        let newItem = Item()
        guard !(titleTextField.text ?? "").isEmpty, !(costTextField.text ?? "").isEmpty else {
        alert(message: "未入力です")
            return
        }
        newItem.title = titleTextField.text!
        newItem.date = selectedDate.date
        newItem.week = inputViewModel.getWeekNumber(date: selectedDate.date)
        newItem.cost = costTextField.textToInt
        
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(newItem)
                print("item saved")
                alert()
            })
        }catch {
            print("save failed")
        }
    }
    
    func alert() {
        let dialog = UIAlertController(title: "", message: "追加できました！", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(dialog, animated: true, completion: nil)
    }
    
    private func alert(message: String) {
        let dialog = UIAlertController(title: "",message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(action)
        present(dialog, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
