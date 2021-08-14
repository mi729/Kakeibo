//
//  TableFooterView.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/08/14.
//  
//

import UIKit

class TableFooterView: UITableViewHeaderFooterView {
    static let identifier = "TableFooterView"

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "合計"
            titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    @IBOutlet weak var sumLabel: UILabel! {
        didSet {
            sumLabel.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configure(sum: Int) {
        sumLabel.text = "\(sum) 円"
    }
}
