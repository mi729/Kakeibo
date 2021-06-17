//
//  InputViewController.swift
//  WeeklyKakeibo
//
//  Created by fuchihashi on 2021/06/14.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "家計簿を追加"
        }
    }
    @IBOutlet weak var weekLabel: UILabel! {
        didSet {
            weekLabel.text = "週"
        }
    }
    
    @IBOutlet weak var weekTextField: UITextField! {
        didSet {
            weekTextField.keyboardType = UIKeyboardType.numberPad
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
    @IBOutlet weak var costTextField: UITextField! {
        didSet {
            costTextField.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.setTitle("追加する", for: .normal)
        }
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        addItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }

    private func addItem() {
        let newItem = Item()
        guard !(titleTextField.text ?? "").isEmpty, !(weekTextField.text ?? "").isEmpty, !(costTextField.text ?? "").isEmpty else {
        alert(message: "未入力です")
            return
        }
        newItem.title = titleTextField.text!
        newItem.date = selectedDate.date
        newItem.week = Int(weekTextField.text!)!
        newItem.cost = Int(costTextField.text!)!
        
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(newItem)
                print("item saved")
                aleart()
            })
        }catch {
            print("save failed")
        }
    }
    
    func aleart() {
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
