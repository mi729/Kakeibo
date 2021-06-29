//
//  FirstViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/23.
//  
//

import UIKit

class FirstView: UIView {
    
    var backgroundView: UIView!
    var view: UIView!
    var settingButton: CustomButton!
    var startButton: CustomButton!
    let notificationCenter = NotificationCenter.default
    
    private let STORED_KEY = "lanched"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIView()
        backgroundView.frame.size = self.frame.size
        backgroundView.backgroundColor = UIColor.white
        self.addSubview(backgroundView)

        view = UIView()
        self.view.frame.size = self.frame.size
        self.setGradient(view: view)
        self.addLabel(view: view)
        settingButton = setSettingButton()
        startButton = setStartButton()
        self.backgroundView.addSubview(view)
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
    
    func addLabel(view: UIView) {
        let label = UILabel()
        label.text = "Weekly家計簿は\n\n1週間分の費用を決めて記録する\n\n「お金の管理が苦手な人」\n\nのためのアプリです"
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
    }
    
    func setSettingButton() -> CustomButton{
        let button = CustomButton()
        button.frame = view.frame
        button.setTitle("貯金額を設定する", for: .normal)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -184).isActive = true
        button.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
        return button
        
    }
    
    func setStartButton() -> CustomButton {
        let button = CustomButton()
        button.frame = view.frame
        button.setTitle("設定せずにはじめる", for: .normal)
        button.backgroundColor = UIColor.systemGray2
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        button.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        notificationCenter.post(name: .startButtonTapped, object: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.backgroundView.center.y += self.frame.height
        }, completion: {_ in
            self.removeFromSuperview()
            self.logFirstLanch()
        })
    }
    
    @objc func settingButtonTapped(_ sender: UIButton) {
        notificationCenter.post(name: .settingButtonTapped, object: nil)
    }
    
    func logFirstLanch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
}

extension Notification.Name {
    static let startButtonTapped = Notification.Name("startButtonTapped")
    static let settingButtonTapped = Notification.Name("settingButtonTapped")
}
