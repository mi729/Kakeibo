//
//  SettingViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/04.
//  
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var yosanLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var yenLabel: UILabel!
    @IBOutlet weak var editButton: CustomButton! {
        didSet {
            editButton.setTitle("編集する", for: .normal)
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        moveToEditView()
    }

    private let weeklyMoney = UserDefaults.standard.integer(forKey: "weeklyMoney")
    private let globalVar = GlobalVar.shared
    
    var base: [[String: Int]] = []
    var cost: [[String: Int]] =  []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSettings()
        setUI()
        setBaseCost()
    }

    private func tableViewSettings() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        settingTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }
    
    private func setBaseCost() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        for (index, amount) in globalVar.amounts.enumerated() {
            guard let data = UserDefaults.standard.data(forKey: amount),
                let decodedData = try? jsonDecoder.decode(Amount.self, from: data) else {
                continue
            }
            if index <= 1 {
                base.append([decodedData.name:decodedData.value])
                continue
            }
            cost.append([decodedData.name:decodedData.value])
        }
    }

    private func setUI() {
        self.navigationController?.navigationBar.tintColor = .white
        yosanLabel.text = "1週間の予算"
        amountLabel.text = "\(weeklyMoney)"
        yenLabel.text = "円"
    }
    private func moveToEditView() {
        let vc = SetSavingAmountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) 
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return base.count
        } else {
            return cost.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isBaseSection = indexPath.section == 0
        let array = isBaseSection ? base : cost
        
        var keyArray: [String] = []
        var valueArray: [Int] = []
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            for amount in array {
                keyArray.append(contentsOf: amount.keys)
                valueArray.append(contentsOf: amount.values)
            }
            cell.nameLabel.text = keyArray[indexPath.row]
            cell.costLabel.text = "\(valueArray[indexPath.row]) 円"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
    }
}
