//
//  TrendsViewController.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import UIKit
import Charts

/*
 *--------------------- Incomplete -----------------------*
*/

class TrendsViewController: UIViewController {
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height/1.5
    var isPresenting = false
    
    var chartView = LineChartView()
    
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
        
        menuView.addSubview(chartView)
//        var dataEntries: [ChartDataEntry] = []
//        if let userData = userData {
//            for i in 0..<userData.count {
//                let dataEntry = ChartDataEntry(x: Double(userData[i].heartRate ?? 0), y: Double(i))
//              dataEntries.append(dataEntry)
//            }
//            let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
//            let lineChartData = LineChartData(dataSet: lineChartDataSet)
//            chartView.data = lineChartData
//        }
    }
    
    override func viewWillLayoutSubviews() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 20).isActive = true
        chartView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20).isActive = true
        chartView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20).isActive = true
        chartView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrendsViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
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
