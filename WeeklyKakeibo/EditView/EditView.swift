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


    @IBOutlet weak var titleTextField: DoneTextFierd! {
        didSet {
            titleTextField.borderStyle = .none
        }
    }
    @IBOutlet weak var cancelButton: CustomButton! {
        didSet {
            cancelButton.backgroundColor = .systemGray2
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        notificationCenter.post(name: .showKakeiboView, object: nil)
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
}
