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
        self.setGradient(view: view)
        
    }
    
    func setGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 88/256.0, green: 188/256.0, blue: 181/256.0, alpha: 1).cgColor
        let color2 = UIColor.white
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5 , y:1 )
        view.layer.insertSublayer(gradientLayer,at:0)
    }
    
//    @objc func startButtonTapped(_ sender: UIButton) {
//        notificationCenter.post(name: .startButtonTapped, object: nil)
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
//            self.view.center.y += self.frame.height
//        }, completion: nil)
//        
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
//            self.backgroundView.center.y += self.frame.height
//        }, completion: {_ in
//            self.removeFromSuperview()
//            self.logFirstLanch()
//        })
//    }
    
}
