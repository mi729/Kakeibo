//
//  TableHeaderView.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/20.
//

import UIKit

class TableHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            titleLabel.textAlignment = .left
        }
    }
    
    @IBOutlet weak var budgetRemainingLabel: UILabel! {
        didSet {
            budgetRemainingLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            budgetRemainingLabel.textAlignment = .right
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
        let view = Bundle.main.loadNibNamed("TableHeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configure(title: String, remaining: Int) {
        titleLabel.text = title
        budgetRemainingLabel.text = "\(remaining) 円"
    }
}
