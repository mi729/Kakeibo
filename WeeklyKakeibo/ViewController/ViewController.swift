//
//  ViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/08.
//

import UIKit
import RealmSwift
import Instructions

class ViewController: UIViewController {
    private lazy var date = getDate()
    private var realm: Realm!
    private var token: NotificationToken!
    private let current = Calendar.current
    private var monthCounter: Int = 0
    private let STORED_KEY = "launched"
    private var firstView = FirstView()
    
    let addKakeiboExplainText = "タップして記録できます"
    let settingExplainText = "予算を確認・編集できます"
    
    var itemList: Results<Item>!
    let notificationCenter = NotificationCenter.default
    let sectionTitleList = ["1週目", "2週目", "3週目", "4週目", "5週目"]
    
    let coachMarksController = CoachMarksController()
    var pointOfInterest: UIView!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBAction func prevButton(_ sender: Any) {
        prevMonth()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        nextMonth()
    }
    
    @IBOutlet weak var settingButton: UIButton! {
        didSet {
            settingButton.imageView?.contentMode = .scaleAspectFit
            settingButton.contentHorizontalAlignment = .fill
            settingButton.contentVerticalAlignment = .fill
        }
    }

    @IBOutlet weak var plusButton: UIButton! {
        didSet {
            plusButton.setTitleColor(.white, for: .normal)
            plusButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.737254902, blue: 0.7098039216, alpha: 1)
            plusButton.layer.cornerRadius = 40.0
        }
    }
    @IBOutlet weak var tableView: UITableView!

    @IBAction func settingButtonTapped(_ sender: Any) {
        toSettingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: .showKakeiboView, object: nil)
        notificationCenter.addObserver(self, selector: #selector(toSetAmountView), name: .settingButtonTapped, object: nil)
        
        tableViewSettings()
        coachMarkSettings()
        setNavBar()
        
        if launchIsFirstTime() {
            setFirstView()
        }
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        
        if !firstView.isDescendant(of: self.view) {
            self.navigationController?.setNavigationBarHidden(false, animated:true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if firstView.isDescendant(of: self.view) {
            self.firstView.removeFromSuperview()
        }
    }
    
    private func logFirstLaunch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
    private func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    private func coachMarkSettings() {
        self.coachMarksController.dataSource = self
    }
    
    private func reload() {
        date = getDate()
        
        let firstDay: NSDate? = date.startOfMonth as NSDate?
        let lastDay: NSDate? = date.endOfMonth as NSDate?
        
        realm = try! Realm()
        let predicate = NSPredicate("date", fromDate: firstDay, toDate:  lastDay)
        itemList = realm.objects(Item.self).filter(predicate)
        
        setNavTitle()
        tableView.reloadData()
    }
    
    private func setNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        self.navigationController?.navigationBar.barTintColor = UIColor {_ in return #colorLiteral(red: 0.3445842266, green: 0.7374812961, blue: 0.7090910673, alpha: 1)}
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setNavTitle()
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    private func setNavTitle() {
        let month = current.component(.month, from: date)
        navTitle.title = "\(month)月"
    }
    
    private func setFirstView() {
        firstView = FirstView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(firstView)
        self.navigationController?.setNavigationBarHidden(true, animated:true)
    }
    
    private func launchIsFirstTime() -> Bool {
        return !UserDefaults.standard.bool(forKey: STORED_KEY)
    }
    
    private func toSettingView() {
        let vc = SettingViewController.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    private func nextMonth() {
        monthCounter += 1
        reload()
    }

    private func prevMonth() {
        monthCounter -= 1
        reload()
    }
    
    private func getDate() -> Date {
        let currentDate = Date()
        let displayDate = Calendar.current.date(byAdding: .month, value: monthCounter, to: currentDate)!
        return displayDate
    }
    
    func getSumOfWeeks() -> [Int] {
        var sumOfWeeks:[Int] = []
        for (index, _) in sectionTitleList.enumerated() {
            let weekItemList = self.getWeekItemList(week: index + 1)
            let sum: Int = weekItemList.sum(ofProperty: "cost")
            sumOfWeeks.append(sum)
        }
        return sumOfWeeks
    }

    func getWeekItemList(week: Int) -> Results<Item> {
        self.realm = try! Realm()
        let predicate = NSPredicate(format: "week == %d", week)
        let weekItemList = itemList.filter(predicate)
        return weekItemList
    }
    
    @objc func updateUI() {
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        if launchIsFirstTime() {
            self.coachMarksController.start(in: .window(over: self))
            self.coachMarksController.overlay.isUserInteractionEnabled = true
            logFirstLaunch()
        }
    }
    
    @objc func toSetAmountView() {
        let vc = SetSavingAmountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: CoachMarksControllerDataSource,
                          CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            self.pointOfInterest = self.plusButton
        case 1:
            self.pointOfInterest = self.settingButton
        default:
            break
        }
        return coachMarksController.helper.makeCoachMark(for: pointOfInterest)
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
        var hintText = ""
        
        switch index {
        case 0:
            hintText = self.addKakeiboExplainText
        case 1:
            hintText = self.settingExplainText
        default:
            break
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: hintText,
            nextText: nil
        )
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
