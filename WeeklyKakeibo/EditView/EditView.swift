//
//  EditView.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/08/02.
//  
//

import UIKit

class EditView: UIView {
    let mainBoundSize: CGSize = UIScreen.main.bounds.size
    let notificationCenter = NotificationCenter.default

    let kakeiboListViewModel = KakeiboListViewModel()
    var item = Item()
    
    @IBOutlet weak var editView: UIView! {
        didSet {
            editView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var titleTextField: DoneTextFierd! {
        didSet {
            titleTextField.borderStyle = .none
        }
    }
    @IBOutlet weak var costTextField: CustomTextField!
    @IBOutlet weak var cancelButton: CustomButton! {
        didSet {
            cancelButton.backgroundColor = .systemGray2
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        notificationCenter.post(name: .showKakeiboView, object: nil)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        editItem()
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("EditView", owner: self, options: nil)?.first as! UIView
        view.frame.size = mainBoundSize
        self.addSubview(view)
    }
    
    func configure(item: Item) {
        titleTextField.text = item.title
        costTextField.text = String(item.cost)
        self.item = item
    }
    
    private func editItem() {
        print(item)
        let newTitle = titleTextField.text ?? ""
        let newCost = costTextField.textToInt
        kakeiboListViewModel.editItem(item: item, newTitle: newTitle, newCost: newCost)
        notificationCenter.post(name: .showKakeiboView, object: nil)
    }
}
