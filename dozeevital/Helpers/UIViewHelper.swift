//
//  UIViewHelper.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

//let keyWindow = UIApplication.shared.connectedScenes.lazy.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }.first?.windows.first { $0.isKeyWindow }

extension UIViewController {
    func setupSafeAreaView() -> UIView {
        let mainView = UIView()
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                mainView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: mainView.bottomAnchor, multiplier: 1.0)
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                mainView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: standardSpacing)
            ])
        }
        return mainView
    }
}

extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }
    
    
    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
        }
    }
    
    
    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            self = CGRect(x: x, y: newValue - height, width: width, height: height)
        }
    }
    
    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        set {
            self = CGRect(x: newValue - width, y: y, width: width, height: height)
        }
    }
    
    
    var midX: CGFloat {
        get {
            return self.x + self.width / 2
        }
        set {
            self = CGRect(x: newValue - width / 2, y: y, width: width, height: height)
        }
    }
    
    var midY: CGFloat {
        get {
            return self.y + self.height / 2
        }
        set {
            self = CGRect(x: x, y: newValue - height / 2, width: width, height: height)
        }
    }
    
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self = CGRect(x: newValue.x - width / 2, y: newValue.y - height / 2, width: width, height: height)
        }
    }
}

func showToast(_ message: String) {
    DispatchQueue.main.async {
        if message.count > 0 {
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return}
            let messageLbl = UILabel()
            messageLbl.textAlignment = .center
            messageLbl.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            messageLbl.textAlignment = .center
            messageLbl.textColor = UIColor.white
            messageLbl.font = UIFont.nunitoBold(ofSize: 16)
            messageLbl.text = message
            messageLbl.numberOfLines = 0
            messageLbl.alpha = 1
            messageLbl.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: CGFloat.greatestFiniteMagnitude)
            messageLbl.sizeToFit()
            let textSize:CGSize = messageLbl.intrinsicContentSize
            let labelWidth = min(textSize.width, window.frame.width - 60)
            messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: messageLbl.frame.height + 20)
            messageLbl.center.x = window.center.x
            messageLbl.layer.cornerRadius = 5
            messageLbl.layer.masksToBounds = true
            window.addSubview(messageLbl)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.8, animations: {
                    messageLbl.alpha = 0
                }) { (_) in
                    messageLbl.removeFromSuperview()
                }
            }
        }
    }
}

func PDFWithScrollView(scrollview: UIScrollView) -> Data {
    let pageDimensions = scrollview.bounds
    
    let pageSize = pageDimensions.size
    let totalSize = scrollview.contentSize
    
    let numberOfPagesThatFitHorizontally = Int(ceil(totalSize.width / pageSize.width))
    let numberOfPagesThatFitVertically = Int(ceil(totalSize.height / pageSize.height))
    
    let outputData = NSMutableData()
    
    UIGraphicsBeginPDFContextToData(outputData, pageDimensions, nil)
        
    let savedContentOffset = scrollview.contentOffset
    let savedContentInset = scrollview.contentInset
    
    scrollview.contentInset = UIEdgeInsets.zero
    
    if let context = UIGraphicsGetCurrentContext() {
        for indexHorizontal in 0 ..< numberOfPagesThatFitHorizontally {
            for indexVertical in 0 ..< numberOfPagesThatFitVertically {
                
                UIGraphicsBeginPDFPage()
                
                let offsetHorizontal = CGFloat(indexHorizontal) * pageSize.width
                let offsetVertical = CGFloat(indexVertical) * pageSize.height
                
                scrollview.contentOffset = CGPoint(x: offsetHorizontal, y: offsetVertical)
                context.translateBy(x: -offsetHorizontal, y: -offsetVertical) // NOTE: Negative offsets
                
                scrollview.layer.render(in: context)
            }
        }
    }
    UIGraphicsEndPDFContext()
    
    scrollview.contentInset = savedContentInset
    scrollview.contentOffset = savedContentOffset
    
    return outputData as Data
}
