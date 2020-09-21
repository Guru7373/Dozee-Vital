//
//  EmailViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let openMailBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appThemeColor
        view.addSubview(openMailBtn)
        
        openMailBtn.setTitle("    Open Mail    ", for: .normal)
        openMailBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        openMailBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        openMailBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        openMailBtn.layer.cornerRadius = 8
        openMailBtn.layer.masksToBounds = true
        openMailBtn.addTarget(self, action: #selector(self.openMail(_:)), for: .touchDown)
    }
    
    @objc func openMail(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else { return }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([supportEmail])
        
        if let userName = userDetail?.name {
            mail.setSubject(userName + subjectLine)
        }

        present(mail, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error { controller.dismiss(animated: true) }
        switch result {
        case .sent:
            showToast("Mail sent.")
        case .saved:
            showToast("Mail saved as draft.")
        case .failed:
            showToast("Failed to send mail.")
        case .cancelled:
            break
        default:
            showToast("error")
        }
        controller.dismiss(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        openMailBtn.translatesAutoresizingMaskIntoConstraints = false
        openMailBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openMailBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        openMailBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
