//
//  KnowMoreViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import UIKit

class KnowMoreViewController: UIViewController {
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height/1.5
    var isPresenting = false
        
    let understandLabel = UILabel()
    let downArrow = UIImageView(image: #imageLiteral(resourceName: "DownArrow"))
    let contentTextView = UITextView()
    let knowMoreBtn = UIButton(type: .system)
    
    var index: Int?
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        self.index = index
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
        
        menuView.addSubview(understandLabel)
        menuView.addSubview(downArrow)
        menuView.addSubview(knowMoreBtn)
        menuView.addSubview(contentTextView)
        
        understandLabel.font = .nunitoSemiBold(ofSize: 14)
        understandLabel.textColor = .white
        
        knowMoreBtn.setTitle("    Know More    ", for: .normal)
        knowMoreBtn.setTitleColor(UIColor(hexString: "#303376"), for: .normal)
        knowMoreBtn.titleLabel?.font = .nunitoSemiBold(ofSize: 11)
        knowMoreBtn.layer.cornerRadius = 4
        knowMoreBtn.layer.masksToBounds = true
        knowMoreBtn.backgroundColor = .white
        
        contentTextView.isEditable = false
        contentTextView.showsVerticalScrollIndicator = false
        contentTextView.isSelectable = false
        contentTextView.backgroundColor = .clear
        contentTextView.textColor = .white
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        contentTextView.attributedText = NSAttributedString(string: HeartRateContent.content, attributes: [NSAttributedString.Key.paragraphStyle : style])
        contentTextView.font = .nunitoRegular(ofSize: 11)
        
        switch index {
        case 0:
            understandLabel.text = "Understand Heart Rate"
            contentTextView.text = HeartRateContent.content + HeartRateContent.ranges
        case 1:
            understandLabel.text = "Understand Respiration Rate"
            contentTextView.text = BreathRateContent.content + BreathRateContent.ranges
        case 2:
            understandLabel.text = "Understand Oxygen Saturation"
            contentTextView.text = OxygenSaturationContent.content + OxygenSaturationContent.ranges
        case 3:
            understandLabel.text = "Understand Blood Pressure"
            contentTextView.text = BloodPressureContent.content + BloodPressureContent.ranges
        case 4:
            understandLabel.text = "Understand Sleep Score"
            contentTextView.text = SleepScoreContent.content + SleepScoreContent.ranges
        case 5:
            understandLabel.text = "Understand Recovery"
            contentTextView.text = RecoveryContent.content + RecoveryContent.ranges
        default:
            break
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
        
    override func viewWillLayoutSubviews() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        understandLabel.translatesAutoresizingMaskIntoConstraints = false
        understandLabel.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 25).isActive = true
        understandLabel.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 16).isActive = true
        
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 32).isActive = true
        downArrow.leadingAnchor.constraint(equalTo: understandLabel.trailingAnchor, constant: 20).isActive = true
        downArrow.widthAnchor.constraint(equalToConstant: 6).isActive = true
        downArrow.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        knowMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        knowMoreBtn.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -16).isActive = true
        knowMoreBtn.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -16).isActive = true
        knowMoreBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.topAnchor.constraint(equalTo: understandLabel.bottomAnchor, constant: 25).isActive = true
        contentTextView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 16).isActive = true
        contentTextView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -16).isActive = true
        contentTextView.bottomAnchor.constraint(equalTo: knowMoreBtn.topAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KnowMoreViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
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
