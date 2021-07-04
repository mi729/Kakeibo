//
//  AlertViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/02.
//  
//

import UIKit
import RealmSwift

class AlertViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var alertView: UIView!{
        didSet {
            alertView.backgroundColor = .white
            alertView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var okButton: CustomButton! {
        didSet {
            okButton.backgroundColor = .systemGray2
        }
    }
    @IBAction func okButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.notify()
        })
    }
    
    let notificationCenter = NotificationCenter.default
    let money: Money? = {
            let realm = try! Realm()
            let results = realm.objects(Money.self)
            let money = results.first
            return money
    }()
    var weeklyMoney: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcMoney()
        moneyLabel.text = "\(weeklyMoney)円"
    }

    private func notify() {
        notificationCenter.post(name: .okButtonTapped, object: nil)
        notificationCenter.post(name: .startButtonTapped, object: nil)
    }
    
    private func calcMoney() {
        guard let money = money else {
            return
        }
        let fixedCosts: Int = money.rent + money.utility + money.water + money.internet + money.insurance + money.other1 + money.other2 + money.savings
        let income = money.income
        weeklyMoney = (income - fixedCosts) / 5
    }
}
