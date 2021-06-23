//
//  FirstViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/23.
//  
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var button: UIButton! {
        didSet {
            
            button.setTitle("はじめる", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor {_ in return #colorLiteral(red: 0.3445842266, green: 0.7374812961, blue: 0.7090910673, alpha: 1)}
            button.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "Weekly家計簿は\n\n1週間分の費用を決めて\n\n記録するアプリです"
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
