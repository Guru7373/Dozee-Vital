//
//  OnBoardViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class OnBoardViewController: UIViewController {
    
    //mainView is used to constraint to safeAreaLayoutGuide, and is added to parentview (view)
    var mainView = UIView()
    
    let onBoardTableView = UITableView()
    let reuseCellId = "cellID"
    
    let continueBtn = UIAnimationButton(type: .system)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appThemeColor
        
        mainView = setupSafeAreaView()

        setupViews()
    }
    
    fileprivate func setupViews() {
        mainView.addSubview(onBoardTableView)
        onBoardTableView.backgroundColor = appThemeColor
        onBoardTableView.register(OnBoardTableViewCell.self, forCellReuseIdentifier: reuseCellId)
        onBoardTableView.delegate = self
        onBoardTableView.dataSource = self
        onBoardTableView.separatorStyle = .none
        onBoardTableView.isScrollEnabled = false
        onBoardTableView.showsVerticalScrollIndicator = false
        
        mainView.addSubview(continueBtn)
        continueBtn.setTitle("Continue", for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.titleLabel?.font = .nunitoRegular(ofSize: 18)
        continueBtn.backgroundColor = .systemBlue
        continueBtn.cornerRadius = 10
        continueBtn.addTarget(self, action: #selector(self.continueAction(_:)), for: .touchUpInside)
    }
    
    @objc func continueAction(_ sender: UIAnimationButton) {
        sender.startAnimation()
        ///Set true for OnBoarded, so that the screen is shown only once.
        UserDefaults.standard.set(true, forKey: UserDefaultKey.didCompleteSplash)

        DispatchQueue.main.async {
            sender.stopAnimation()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            sceneDelegate.window?.rootViewController = TabBarController()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        onBoardTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            onBoardTableView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: -90),
            onBoardTableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            onBoardTableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            onBoardTableView.heightAnchor.constraint(equalToConstant: CGFloat(110*OnBoardList.title.count))
        ])
        
        continueBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueBtn.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -80),
            continueBtn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            continueBtn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            continueBtn.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

extension OnBoardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        
        let appTitleLabel = UILabel()
        appTitleLabel.text = "Dozee Vitals"
        appTitleLabel.font = .nunitoBold(ofSize: 24)
        appTitleLabel.textColor = .white
        headerView.addSubview(appTitleLabel)
        
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        appTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        appTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnBoardList.title.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath) as! OnBoardTableViewCell
        tableCell.backgroundColor = appThemeColor
        tableCell.selectionStyle = .none
        
        tableCell.iconView.image = OnBoardList.icon[indexPath.row]?.withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        
        tableCell.titleLabel.text = OnBoardList.title[indexPath.row]
        tableCell.titleLabel.numberOfLines = 0
        tableCell.titleLabel.textColor = .white
        tableCell.titleLabel.font = .nunitoBold(ofSize: 17)
        
        tableCell.subtitleLabel.text = OnBoardList.subtitle[indexPath.row]
        tableCell.subtitleLabel.numberOfLines = 0
        tableCell.subtitleLabel.textColor = .white
        tableCell.subtitleLabel.font = .nunitoRegular(ofSize: 15)
    
        return tableCell
    }
}
