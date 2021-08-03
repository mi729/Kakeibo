//
//  ViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/08.
//

import UIKit
import RealmSwift
import Instructions

class KakeiboListViewController: UIViewController {
    private var realm: Realm!
    private var token: NotificationToken!
    private let current = Calendar.current
    private var monthCounter: Int = 0
    private let STORED_KEY = "launched"
    private var firstView = FirstView()
    private var editView = EditView()

    let addKakeiboExplainText = "タップして記録できます"
    let settingExplainText = "予算を確認・編集できます"
    
    var itemList: Results<Item>!
    let notificationCenter = NotificationCenter.default
    let sectionTitleList = ["1週目", "2週目", "3週目", "4週目", "5週目"]
    
    let coachMarksController = CoachMarksController()
    var pointOfInterest: UIView!
    
    var openedSections = Set<Int>()
    
    let kakeiboListViewModel = KakeiboListViewModel()
    let inputViewModel = InputViewModel()
    
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
        removeView(firstView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showEditView() {
        editView = EditView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(editView)
    }

    private func removeView(_ view: UIView) {
        if view.isDescendant(of: self.view) {
            view.removeFromSuperview()
        }
    }
    
    private func openCurrentSectionWeek() {
        if monthCounter != 0 {
            openedSections.removeAll()
            return
        }
        let section = inputViewModel.getWeekNumber(date: Date()) - 1
        openedSections.insert(section)
    }

    private func logFirstLaunch() {
        return UserDefaults.standard.set(true, forKey: STORED_KEY)
    }
    
    private func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    private func coachMarkSettings() {
        self.coachMarksController.dataSource = self
    }
    
    private func reload() {
        let displayDate = kakeiboListViewModel.getDisplayDate(monthCounter: monthCounter)
        let firstDay: NSDate? = displayDate.startOfMonth as NSDate?
        let lastDay: NSDate? = displayDate.endOfMonth as NSDate?
        
        realm = try! Realm()
        let predicate = NSPredicate("date", fromDate: firstDay, toDate:  lastDay)
        itemList = realm.objects(Item.self).filter(predicate)
        
        openCurrentSectionWeek()
        setNavTitle()
        tableView.reloadData()
    }
    
    private func setNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Navigation")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setNavTitle()
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    private func setNavTitle() {
        let displayDate = kakeiboListViewModel.getDisplayDate(monthCounter: monthCounter)
        let month = current.component(.month, from: displayDate)
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
    
    @objc func updateUI() {
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        removeView(editView)
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

extension KakeiboListViewController: CoachMarksControllerDataSource,
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
        
        coachViews.bodyView.background.innerColor = #colorLiteral(red: 0.3470028212, green: 0.3599076705, blue: 0.3486330877, alpha: 1)
        coachViews.bodyView.hintLabel.textColor = .white
        coachViews.arrowView?.background.innerColor = #colorLiteral(red: 0.3470028212, green: 0.3599076705, blue: 0.3486330877, alpha: 1)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
