//
//  TableHeaderView.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/20.
//

import UIKit

    class TableHeader: UITableViewHeaderFooterView {
        static let identifier = "TableHeader"
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Week"
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            label.textColor = UIColor.darkGray
            label.textAlignment = .left
            return label
        }()
        
        private let sumLabel: UILabel = {
            let label = UILabel()
            label.text = "10000円"
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            label.textColor = UIColor.darkGray
            label.textAlignment = .right
            return label
        }()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            contentView.addSubview(titleLabel)
            contentView.addSubview(sumLabel)
            contentView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(title: String, sum: Int) {
            titleLabel.text = title
            sumLabel.text = "¥\(sum)"
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: 16,
                                      y: contentView.frame.size.height-10-titleLabel.frame.size.height,
                                      width: contentView.frame.size.width / 2,
                                      height: titleLabel.frame.size.height)
            sumLabel.frame = CGRect(x: contentView.frame.size.width / 2,
                                      y: contentView.frame.size.height-10-titleLabel.frame.size.height,
                                      width: contentView.frame.size.width / 2 - 16,
                                      height: titleLabel.frame.size.height)
        }
    }
