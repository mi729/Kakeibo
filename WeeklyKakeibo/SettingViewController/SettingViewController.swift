//
//  SettingViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/04.
//  
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    private var realm: Realm!
    
    let money: Money? = {
            let realm = try! Realm()
            let results = realm.objects(Money.self)
            let money = results.first
            return money
    }()
    
    lazy var base: KeyValuePairs = ["1ヶ月の手取り":money?.income, "貯金額":money?.savings]
    lazy var cost: KeyValuePairs =  ["家賃":money?.rent, "光熱費":money?.utility, "水道代":money?.water, "ネット・スマホ代":money?.internet, "保険":money?.insurance, "その他1":money?.other1, "その他2":money?.other2]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSettings()
        setNavBar()
    }

    private func tableViewSettings() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        settingTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }
    

    private func setNavBar() {
        self.navigationController?.navigationBar.tintColor = .white
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
        let isBase = indexPath.section == 0
        let array = isBase ? base : cost
        
        var keyArray: [String] = []
        var valueArray: [Int] = []
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            for (key,value) in array {
                print(key,value)
                keyArray.append(key)
                valueArray.append(value ?? 0)
            }
            cell.nameLabel.text = keyArray[indexPath.row]
            cell.costLabel.text = "¥\(valueArray[indexPath.row])"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
    }
}
