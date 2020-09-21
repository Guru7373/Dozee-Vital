//
//  TabBarController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class TabBarController: UIViewController {

    let tabBar = UITabBarController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.barTintColor = UIColor.themeConvertor(dark: "#1C184E", light: "#1C184E")
        tabBar.tabBar.tintColor = UIColor.themeConvertor(dark: "#7DBAE1", light: "#7DBAE1")
        tabBar.tabBar.shadowImage = UIImage()

        createTabBarController()
    }
    
    private func createTabBarController() {
        let home = HomeViewController()
        home.title = "Vitals"
        home.tabBarItem = UITabBarItem.init(title: "Vitals", image: UIImage(named: "Group 5599"), tag: 0)

        let call = CallViewController()
        call.title = "Call"
        call.tabBarItem = UITabBarItem.init(title: "Call", image: UIImage(named: "Call"), tag: 1)

        let email = EmailViewController()
        email.title = "Email"
        email.tabBarItem = UITabBarItem.init(title: "Email", image: UIImage(named: "Email"), tag: 2)

        let whatsapp = WhatsAppViewController()
        whatsapp.title = "Whats App"
        whatsapp.tabBarItem = UITabBarItem.init(title: "Whats App", image: UIImage(named: "whatsapp"), tag: 3)

        let controllerArray = [home, call, email, whatsapp]
        
        tabBar.viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
        
        self.view.addSubview(tabBar.view)
    }
}
