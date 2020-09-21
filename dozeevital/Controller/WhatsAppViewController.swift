//
//  WhatsAppViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class WhatsAppViewController: UIViewController {

    let openWhatsappBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appThemeColor
        view.addSubview(openWhatsappBtn)
        
        openWhatsappBtn.setTitle("    Open Whatsapp    ", for: .normal)
        openWhatsappBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        openWhatsappBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        openWhatsappBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        openWhatsappBtn.layer.cornerRadius = 8
        openWhatsappBtn.layer.masksToBounds = true
        openWhatsappBtn.addTarget(self, action: #selector(self.openWhatsapp(_:)), for: .touchDown)
    }
    
    @objc func openWhatsapp(_ sender: UIButton) {
        let urlWhats = "whatsapp://send?phone=\(supportCC + supportNumber)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                } else {
                    showToast("Please install Whatsapp.")
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        openWhatsappBtn.translatesAutoresizingMaskIntoConstraints = false
        openWhatsappBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openWhatsappBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        openWhatsappBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
