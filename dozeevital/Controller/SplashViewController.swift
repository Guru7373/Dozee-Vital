//
//  SplashViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class SplashViewController: UIViewController {

    let splashImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    let splashBtn = UIAnimationButton(type: .system)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appThemeColor
        view.addSubview(splashImageView)
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.didCompleteSplash) == nil {
            UserDefaults.standard.set(false, forKey: UserDefaultKey.didCompleteSplash)
        }
        
        if UserDefaults.standard.value(forKey: UserDefaultKey.todaysAnswer) == nil {
            UserDefaults.standard.set("", forKey: UserDefaultKey.todaysAnswer)
        }
        
        view.addSubview(splashBtn)
        splashBtn.backgroundColor = .systemBlue
        splashBtn.cornerRadius = 10
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.splashAction(_:)), userInfo: nil, repeats: false)
    }
    
    @objc func splashAction(_ sender: UIAnimationButton) {
        splashBtn.startAnimation()
        let hasOnBoarded = UserDefaults.standard.bool(forKey: UserDefaultKey.didCompleteSplash)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.splashBtn.stopAnimation()
            ///Condition for Showing OnBoard Screen only once...
            if hasOnBoarded {
                sceneDelegate.window?.rootViewController = TabBarController()
            }else{
                let vc = OnBoardViewController()
                vc.isModalInPresentation = true
                self.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        splashImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        splashImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        splashBtn.translatesAutoresizingMaskIntoConstraints = false
        splashBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        splashBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        splashBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        splashBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
