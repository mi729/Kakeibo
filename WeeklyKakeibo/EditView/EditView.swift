//
//  EditView.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/08/02.
//  
//

import UIKit

class EditView: UIView {

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
        view.frame = self.bounds
        self.addSubview(view)
    }
}
