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
    let globalVar = GlobalVar.shared
    var income: Int = 0
    var fixedCost: Int = 0
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
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        for (index, amount) in globalVar.amounts.enumerated() {
            guard let data = UserDefaults.standard.data(forKey: amount),
                let decodedData = try? jsonDecoder.decode(Amount.self, from: data) else {
                continue
            }
            if index == 0 {
                income += decodedData.value
                continue
            }
            fixedCost += decodedData.value
        }
        weeklyMoney = (income - fixedCost) / 5
        UserDefaults.standard.set(weeklyMoney, forKey: "weeklyMoney")
    }
}
