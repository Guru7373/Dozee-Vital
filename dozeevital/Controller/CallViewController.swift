//
//  CallViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class CallViewController: UIViewController {
    
    let callBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appThemeColor
        view.addSubview(callBtn)
        
        callBtn.setTitle("    Call Support    ", for: .normal)
        callBtn.setTitleColor(UIColor(hexString: "#050645"), for: .normal)
        callBtn.backgroundColor = UIColor(hexString: "#7DBAE1")
        callBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 12)
        callBtn.layer.cornerRadius = 8
        callBtn.layer.masksToBounds = true
        callBtn.addTarget(self, action: #selector(self.callAction(_:)), for: .touchDown)
    }
    
    @objc func callAction(_ sender: UIButton) {
        if let phoneURL = URL(string: ("tel://" + supportCC  + supportNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }else{
            showToast("Could not call.")
        }
    }
        
    override func viewWillLayoutSubviews() {
        callBtn.translatesAutoresizingMaskIntoConstraints = false
        callBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        callBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
