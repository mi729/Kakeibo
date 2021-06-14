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
    

    @IBOutlet weak var naiyouLabel: UILabel! {
        didSet {
            naiyouLabel.text = "内容"
        }
    }
    
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let newItem = Item()
        guard let title = titleTextField.text else {
            return
        }
        newItem.title = title
        newItem.date = selectedDate.date
        
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
        let dialog = UIAlertController(title: "追加", message: "追加できました！", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(dialog, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
