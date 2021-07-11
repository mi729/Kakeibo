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
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            label.textAlignment = .left
            return label
        }()
        
        private let sumLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            label.textAlignment = .right
            return label
        }()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            contentView.addSubview(titleLabel)
            contentView.addSubview(sumLabel)
            contentView.backgroundColor = UIColor(named: "ContentBackground")
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(title: String, sum: Int) {
            titleLabel.text = title
            sumLabel.text = "\(sum) 円"
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
