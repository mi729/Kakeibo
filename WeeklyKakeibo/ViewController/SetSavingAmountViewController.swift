//
//  SetSavingAmountViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/28.
//  
//

import UIKit

class SetSavingAmountViewController: UIViewController {

    override func loadView() {
        if let view = UINib(nibName: "SetSavingAmountView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
        self.view = view
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
