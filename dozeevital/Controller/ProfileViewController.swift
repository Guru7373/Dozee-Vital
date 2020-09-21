//
//  ProfileViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import UIKit

class ProfileViewController: UIViewController {
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height/2.2
    var isPresenting = false
    
    var profileLabel = UILabel()
    var userDetailTV = UITextView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        
        menuView.backgroundColor = UIColor(hexString: "#303376")
        menuView.layer.cornerRadius = 10
        menuView.layer.masksToBounds = true
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        backdropView.addGestureRecognizer(tapGesture)
        
        menuView.addSubview(profileLabel)
        profileLabel.text = "My Profile"
        profileLabel.textAlignment = .center
        profileLabel.font = .nunitoExtraBold(ofSize: 24)
        profileLabel.textColor = .white
        
        menuView.addSubview(userDetailTV)
        userDetailTV.isEditable = false
        userDetailTV.isSelectable = false
        userDetailTV.backgroundColor = .clear
        userDetailTV.showsVerticalScrollIndicator = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 15
        userDetailTV.attributedText = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.paragraphStyle : style])
        userDetailTV.font = .nunitoRegular(ofSize: 18)
        userDetailTV.text = "Name :    \(userDetail?.name ?? "-") \n" + "Phone :    \(userDetail?.phone.countryCode ?? "-") - \(userDetail?.phone.number ?? "") \n" + "DOB :    \(userDetail?.dob ?? "-")"
        userDetailTV.textColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 30).isActive = true
        profileLabel.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20).isActive = true
        profileLabel.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20).isActive = true

        userDetailTV.translatesAutoresizingMaskIntoConstraints = false
        userDetailTV.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 20).isActive = true
        userDetailTV.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20).isActive = true
        userDetailTV.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20).isActive = true
        userDetailTV.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting

        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
