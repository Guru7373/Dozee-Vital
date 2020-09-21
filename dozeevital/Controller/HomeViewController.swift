//
//  HomeViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

/// userDetail, Declared Globally because the variable is used in multiple classes
var userDetail: UserDetailsModal?
/// Overall User Data
var userData: UserDataModal?

class HomeViewController: UIViewController {
    let screenSize = UIScreen.main.bounds
    var mainView = UIView()
    
    let customNavView = UIView()
    let profileView = UIButton()
    let nameLabel = UILabel()
    
    let dailyBtn = UIButton()
    let weeklyBtn = UIButton()
    let monthlyBtn = UIButton()
    let shareBtn = UIButton()
    
    let dateLabel = UILabel()
    
    let vitalsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cellResuseID = "cellID"
    
    let apiManager = APIManager()
    
    var userQuestion: UserQuestionModal?
    var todayUserData: UserDataModalElement? // Current date's User Data
    
    let todaysAnswer = UserDefaults.standard.string(forKey: UserDefaultKey.todaysAnswer)
    
    let dateFormatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nil
        
        view.backgroundColor = appThemeColor
        
        mainView = setupSafeAreaView()
    
        setupViews()
        
        //Rest API Call to get User Detail
        apiManager.userDetailProtocol = self
        apiManager.getUserDetails()
        
        ///If already responded for todays Question, then only call User Data API...
        if todaysAnswer == "" {
            self.getUserQuestion()
            self.getUserData()
        } else {
            self.getUserData()
        }
    }
    
    private func setupViews() {
        customNavView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 44)

        customNavView.addSubview(profileView)
        customNavView.addSubview(nameLabel)

        profileView.backgroundColor = UIColor(hexString: "#7BBEE5", alpha: 1.0)
        profileView.setImage(UIImage(named: "Profile"), for: .normal)
        profileView.layer.cornerRadius = 20
        profileView.layer.masksToBounds = true
        
        nameLabel.textAlignment = .center
        nameLabel.font = .nunitoRegular(ofSize: 16)
        nameLabel.textColor = UIColor(hexString: "#E4E4E4")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customNavView)
        customNavView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileAction(_:)))
        customNavView.addGestureRecognizer(tapGesture)
                
        mainView.addSubview(dailyBtn)
        mainView.addSubview(weeklyBtn)
        mainView.addSubview(monthlyBtn)
        mainView.addSubview(shareBtn)
        mainView.addSubview(dateLabel)
        mainView.addSubview(vitalsCollectionView)
        
        dailyBtn.defaultStyle(title: "Daily", font: .nunitoBold(ofSize: 12), cornerRadius: 20)
        dailyBtn.addTarget(self, action: #selector(self.dailyBtnAction(_:)), for: .touchDown)
        dailyBtn.backgroundColor = UIColor(hexString: "#7276BF", alpha: 1.0)
        
        weeklyBtn.defaultStyle(title: "Weekly", font: .nunitoBold(ofSize: 12), cornerRadius: 20)
        weeklyBtn.addTarget(self, action: #selector(self.weeklyBtnAction(_:)), for: .touchDown)
        
        monthlyBtn.defaultStyle(title: "Monthly", font: .nunitoBold(ofSize: 12), cornerRadius: 20)
        monthlyBtn.addTarget(self, action: #selector(self.monthlyBtnAction(_:)), for: .touchDown)
        
        shareBtn.setImage(UIImage(named: "share"), for: .normal)
        shareBtn.setImage(UIImage(named: "share"), for: .selected)
        shareBtn.addTarget(self, action: #selector(self.shareBtnAction(_:)), for: .touchDown)
        
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateLabel.text = "Today,  \(dateFormatter.string(from: Date()))"
        dateLabel.font = .nunitoSemiBold(ofSize: 12)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .white
        
        vitalsCollectionView.register(VitalsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellResuseID)
        vitalsCollectionView.register(VitalsCollectionViewCell.self, forCellWithReuseIdentifier: cellResuseID)
        vitalsCollectionView.delegate = self
        vitalsCollectionView.dataSource = self
        vitalsCollectionView.backgroundColor = .clear
        vitalsCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func getUserQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //Rest API Call to get User Question
            self.apiManager.userQuestionProtocol = self
            self.apiManager.getUserQuestions()
        }
    }
    
    private func getUserData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //Rest API Call to get User Data
            self.apiManager.userDataProtocol = self
            self.apiManager.getUserData()
        }
    }
    
    @objc func profileAction(_ sender: UITapGestureRecognizer) {
        let vc = ProfileViewController()
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
    
    @objc func dailyBtnAction(_ sender: UIButton) {
        dailyBtn.isSelected = true
        weeklyBtn.isSelected = false
        monthlyBtn.isSelected = false
        
        dailyBtn.backgroundColor = UIColor(hexString: "#7276BF", alpha: 1.0)
        weeklyBtn.backgroundColor = .clear
        monthlyBtn.backgroundColor = .clear
                
        dateLabel.text = "Today,  \(dateFormatter.string(from: Date()))"
        calculateData(isWeek: false, isMonth: false)
    }
    
    @objc func weeklyBtnAction(_ sender: UIButton) {
        dailyBtn.isSelected = false
        weeklyBtn.isSelected = true
        monthlyBtn.isSelected = false
        
        dailyBtn.backgroundColor = .clear
        weeklyBtn.backgroundColor = UIColor(hexString: "#7276BF", alpha: 1.0)
        monthlyBtn.backgroundColor = .clear
        if let oneWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
            dateLabel.text = "\(dateFormatter.string(from: oneWeekDate))  -  \(dateFormatter.string(from: Date()))"
        }
        calculateData(isWeek: true, isMonth: false)
    }
    
    @objc func monthlyBtnAction(_ sender: UIButton) {
        dailyBtn.isSelected = false
        weeklyBtn.isSelected = false
        monthlyBtn.isSelected = true
        
        dailyBtn.backgroundColor = .clear
        weeklyBtn.backgroundColor = .clear
        monthlyBtn.backgroundColor = UIColor(hexString: "#7276BF", alpha: 1.0)
                
        if let oneMonthDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
            dateLabel.text = "\(dateFormatter.string(from: oneMonthDate))  -  \(dateFormatter.string(from: Date()))"
        }
        calculateData(isWeek: false, isMonth: true)
    }
    
    func calculateData(isWeek: Bool, isMonth: Bool) {
        if userData?.count ?? 0 > 0 && userData != nil {
            todayUserData = nil
            var averageData = [UserDataModalElement]()
            
            if isWeek {
                if let oneWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
                    for data in userData! {
                        let dateFromData = Date(timeIntervalSince1970: TimeInterval(data.time ?? 0))
                        if dateFromData > oneWeekDate && dateFromData < Date() {
                            averageData.append(data)
                        }
                    }
                }
            } else if isMonth {
                if let oneMonthDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
                    for data in userData! {
                        let dateFromData = Date(timeIntervalSince1970: TimeInterval(data.time ?? 0))
                        if dateFromData > oneMonthDate && dateFromData < Date() {
                            averageData.append(data)
                        }
                    }
                }
            } else {
                if let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                   let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                    for data in userData! {
                        let dateFromData = Date(timeIntervalSince1970: TimeInterval(data.time ?? 0))
                        if dateFromData > yesterdayDate && dateFromData < tomorrowDate {
                            averageData.append(data)
                        }
                    }
                }
            }
            
            if averageData.count > 0 {
                var heartRate = 0, breathRate = 0, O2 = 0, systole = 0, diastole = 0, recovery = 0, sleepScore = 0
                for i in 0..<averageData.count {
                    heartRate += averageData[i].heartRate ?? 0
                    breathRate += averageData[i].breathRate ?? 0
                    O2 += averageData[i].o2 ?? 0
                    systole += averageData[i].bloodPressure?.systole ?? 0
                    diastole += averageData[i].bloodPressure?.diastole ?? 0
                    recovery += averageData[i].recovery ?? 0
                    sleepScore += averageData[i].sleepscore ?? 0
                }
                let bp = Bp(systole: systole/averageData.count, diastole: diastole/averageData.count)
                let average = UserDataModalElement(heartRate: heartRate/averageData.count, breathRate: breathRate/averageData.count, o2: O2/averageData.count, bloodPressure: bp, recovery: recovery/averageData.count, sleepscore: sleepScore/averageData.count, time: nil, bp: bp)
                todayUserData = average
            }
        }
        DispatchQueue.main.async {
            self.vitalsCollectionView.reloadData()
        }
    }
    
    @objc func shareBtnAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            let data = PDFWithScrollView(scrollview: self.vitalsCollectionView)
            if data.count > 0 {
                let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true)
            } else {
                showToast("Could not make pdf...")
            }
        }
    }
    
    @objc func answerAction(_ sender: UIButton) {
        UserDefaults.standard.setValue("\(userQuestion?.answers[sender.tag] ?? "")", forKey: UserDefaultKey.todaysAnswer)
        userQuestion?.answers = [String]()
        DispatchQueue.main.async {
            self.vitalsCollectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyBtn.translatesAutoresizingMaskIntoConstraints = false
        weeklyBtn.translatesAutoresizingMaskIntoConstraints = false
        monthlyBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        vitalsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.leadingAnchor.constraint(equalTo: customNavView.leadingAnchor, constant: 16).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileView.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 12).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor).isActive = true
        
        dailyBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20).isActive = true
        dailyBtn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        dailyBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        dailyBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        weeklyBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20).isActive = true
        weeklyBtn.leadingAnchor.constraint(equalTo: dailyBtn.trailingAnchor, constant: 10).isActive = true
        weeklyBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        weeklyBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        monthlyBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20).isActive = true
        monthlyBtn.leadingAnchor.constraint(equalTo: weeklyBtn.trailingAnchor, constant: 10).isActive = true
        monthlyBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        monthlyBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        shareBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20).isActive = true
        shareBtn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16).isActive = true
        shareBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: dailyBtn.bottomAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16).isActive = true
        
        vitalsCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        vitalsCollectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16).isActive = true
        vitalsCollectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16).isActive = true
        vitalsCollectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UserDefaults.standard.string(forKey: UserDefaultKey.todaysAnswer) == "" {
            return CGSize(width: screenSize.width, height: 130)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellResuseID, for: indexPath) as! VitalsHeaderView
        headerCell.layer.cornerRadius = 8
        headerCell.layer.masksToBounds = true
        
        headerCell.cardView.layer.cornerRadius = 8
        headerCell.cardView.layer.masksToBounds = true
        headerCell.addGradientBackground()

        let greetings = userQuestion?.greeting ?? ""
        let question = userQuestion?.question ?? ""
        
        headerCell.greetingLabel.text = "\(greetings), \(question)"
        headerCell.greetingLabel.numberOfLines = 0
        headerCell.greetingLabel.font = .nunitoBold(ofSize: 12)
        
        headerCell.iconView.image = #imageLiteral(resourceName: "sun")
        
        if userQuestion?.answers.count ?? 0 > 0 && userQuestion?.answers.count ?? 0 <= 3 {
            headerCell.freshBtn.isHidden = false
            headerCell.goodBtn.isHidden = false
            headerCell.tiredBtn.isHidden = false
            headerCell.freshBtn.setTitle("    \(userQuestion?.answers[0].capitalized ?? "")    ", for: .normal)
            headerCell.goodBtn.setTitle("    \(userQuestion?.answers[1].capitalized ?? "")    ", for: .normal)
            headerCell.tiredBtn.setTitle("    \(userQuestion?.answers[2].capitalized ?? "")    ", for: .normal)
        }else{
            headerCell.freshBtn.isHidden = true
            headerCell.goodBtn.isHidden = true
            headerCell.tiredBtn.isHidden = true
        }
        
        headerCell.freshBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        headerCell.freshBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        headerCell.freshBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        headerCell.freshBtn.layer.cornerRadius = 4
        headerCell.freshBtn.layer.masksToBounds = true
        headerCell.freshBtn.tag = 0
        
        headerCell.goodBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        headerCell.goodBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        headerCell.goodBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        headerCell.goodBtn.layer.cornerRadius = 4
        headerCell.goodBtn.layer.masksToBounds = true
        headerCell.goodBtn.tag = 1
        
        headerCell.tiredBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        headerCell.tiredBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        headerCell.tiredBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        headerCell.tiredBtn.layer.cornerRadius = 4
        headerCell.tiredBtn.layer.masksToBounds = true
        headerCell.tiredBtn.tag = 2
        
        headerCell.freshBtn.addTarget(self, action: #selector(self.answerAction(_:)), for: .touchDown)
        headerCell.goodBtn.addTarget(self, action: #selector(self.answerAction(_:)), for: .touchDown)
        headerCell.tiredBtn.addTarget(self, action: #selector(self.answerAction(_:)), for: .touchDown)
        
        return headerCell
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellResuseID, for: indexPath) as! VitalsCollectionViewCell
        
        collectionCell.cardView.backgroundColor = UIColor(hexString: "#1F2142")
        collectionCell.cardView.layer.cornerRadius = 8
        collectionCell.cardView.layer.masksToBounds = true
        
        collectionCell.rightArrow.image = #imageLiteral(resourceName: "rightArrow")
        
        collectionCell.rateLabel.font = .nunitoExtraLight(ofSize: 60)
        
        collectionCell.unitLabel.textColor = .lightGray
        collectionCell.unitLabel.font = .nunitoSemiBold(ofSize: 15)
        
        let unhealthyColor = RangeColors.unhealthy
        
        switch indexPath.row {
        case 0: ///HeartRate
            let color = calculateHeartRate(todayUserData?.heartRate ?? 0)
            collectionCell.rateLabel.text = ((todayUserData?.heartRate ?? 0) != 0) ? "\(todayUserData?.heartRate ?? 0)" : "-"
            collectionCell.unitLabel.text = "BPM"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "Heart").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        case 1: ///BreathRate
            let color = calculateBreathRate(todayUserData?.breathRate ?? 0)
            collectionCell.rateLabel.text = ((todayUserData?.breathRate ?? 0) != 0) ? "\(todayUserData?.breathRate ?? 0)" : "-"
            collectionCell.unitLabel.text = "RPM"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "Respiratory").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        case 2: ///O2
            let color = calculateOxygenSaturation(todayUserData?.o2 ?? 0)
            collectionCell.rateLabel.text = ((todayUserData?.o2 ?? 0) != 0) ? "\(todayUserData?.o2 ?? 0)" : "-"
            collectionCell.unitLabel.text = "%"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "oxygen").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        case 3: ///BP
            let color = calculateBP(todayUserData?.bloodPressure?.systole ?? 0, todayUserData?.bloodPressure?.diastole ?? 0)
            ///Systole \n Diastole
            let systole = ((todayUserData?.bloodPressure?.systole ?? 0) != 0) ? "\(todayUserData?.bloodPressure?.systole ?? 0)" : "-"
            let diastole = ((todayUserData?.bloodPressure?.diastole ?? 0) != 0) ? "\(todayUserData?.bloodPressure?.diastole ?? 0)" : "-"
            collectionCell.rateLabel.text = "\(systole)\n\(diastole)"
            collectionCell.rateLabel.font = .nunitoRegular(ofSize: 27)
            collectionCell.rateLabel.numberOfLines = 0
            collectionCell.unitLabel.text = "mmHg"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "BloodPressure").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = false
            collectionCell.downArrow.isHidden = false
        case 4: ///sleepscore
            let color = calculateSleepScore(todayUserData?.sleepscore ?? 0)
            collectionCell.rateLabel.text = ((todayUserData?.sleepscore ?? 0) != 0) ? "\(todayUserData?.sleepscore ?? 0)" : "-"
            collectionCell.unitLabel.text = "/100"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "sleep").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        case 5: ///Recovery
            let color = calculateRecoveryRate(todayUserData?.recovery ?? 0)
            collectionCell.rateLabel.text = ((todayUserData?.recovery ?? 0) != 0) ? "\(todayUserData?.recovery ?? 0)" : "-"
            collectionCell.unitLabel.text = "%"
            collectionCell.symbolView.image = #imageLiteral(resourceName: "Recovery").withTintColor((color != .clear) ? color : unhealthyColor, renderingMode: .automatic)
            collectionCell.indicator.backgroundColor = color
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        default:
            collectionCell.rateLabel.text = "-"
            collectionCell.unitLabel.text = "-"
            collectionCell.symbolView.image = UIImage()
            collectionCell.indicator.backgroundColor = .clear
            collectionCell.upArrow.isHidden = true
            collectionCell.downArrow.isHidden = true
        }
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = KnowMoreViewController(index: indexPath.row)
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2.1, height: collectionView.frame.size.width/2)
    }
}

extension HomeViewController: UserDetailProtocol, UserQuestionProtocol, UserDataProtocol {
    func userDetailResponse(_ response: UserDetailsModal) {
        userDetail = response
        DispatchQueue.main.async {
            self.nameLabel.text = userDetail?.name ?? ""
        }
    }
    
    func userDetailError(_ error: String) {
        showToast(error)
    }
    
    func userQuestionResponse(_ response: UserQuestionModal) {
        userQuestion = response
        DispatchQueue.main.async {
            self.vitalsCollectionView.reloadData()
        }
    }
    
    func userQuestionError(_ error: String) {
        showToast(error)
    }
    
    func userDataResponse(_ response: UserDataModal) {
        userData = response.reversed()
        calculateData(isWeek: false, isMonth: false)
        DispatchQueue.main.async {
            self.vitalsCollectionView.reloadData()
        }
    }
    
    func userDataError(_ error: String) {
        showToast(error)
    }
}
