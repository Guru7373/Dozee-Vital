//
//  UIButtonHelper.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

public enum StopAnimationStyle {
    case normal
    case expand
    case shake
}

open class UIAnimationButton : UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {
    /// the color of the spinner while animating the button
    open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    private lazy var spiner: SpinerLayer = {
        let spiner = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    private var cachedTitle: String?
    private var cachedImage: UIImage?
    
    private var animating = false
    
    private let springGoEase:CAMediaTimingFunction  = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    private let shrinkCurve:CAMediaTimingFunction   = CAMediaTimingFunction(name: .linear)
    private let expandCurve:CAMediaTimingFunction   = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    private let shrinkDuration: CFTimeInterval      = 0.1
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.spiner.setToFrame(self.frame)
    }
    
    private func setup() {
        self.clipsToBounds  = true
        spiner.spinnerColor = spinnerColor
    }
    
    /**
     start animating the button, before starting a task, exemple: before a network call.
     */
    open func startAnimation() {
        self.isUserInteractionEnabled = false // Disable the user interaction during the animation
        self.cachedTitle            = title(for: .normal)  // cache title before animation of spiner
        self.cachedImage            = image(for: .normal)  // cache image before animation of spiner
        
        self.setTitle("",  for: .normal)                    // place an empty string as title to display a spiner
        self.setImage(nil, for: .normal)                    // remove the image, if any, before displaying the spinner
        self.isAnimating = true
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = 10 // corner radius should be half the height to have a circle corners
        }, completion: { completed -> Void in
            self.shrink()   // reduce the width to be equal to the height in order to have a circle
            self.spiner.animation() // animate spinner
        })
    }
    
    open func stopAnimation(animationStyle:StopAnimationStyle = .normal, revertAfterDelay delay: TimeInterval = 1.0, completion:(()->Void)? = nil) {
        let delayToRevert = max(delay, 0.2)
        self.isAnimating = false
        switch animationStyle {
        case .normal:
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: completion)
            }
        case .shake:
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: nil)
                self.shakeAnimation(completion: completion)
            }
        case .expand:
            self.spiner.stopAnimation()
            self.expand(completion: completion, revertDelay: delayToRevert)
        }
    }
    
    private func shakeAnimation(completion:(()->Void)?) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: point)]
        
        keyFrame.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        keyFrame.duration = 0.7
        self.layer.position = point
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)
        
        CATransaction.commit()
    }
    
    var isAnimating: Bool {
        get {
            return animating
        }
        set {
            animating = newValue
        }
    }
    
    private func setOriginalState(completion:(()->Void)?) {
        self.animateToOriginalWidth(completion: completion)
        self.spiner.stopAnimation()
        self.setTitle(self.cachedTitle, for: .normal)
        self.setImage(self.cachedImage, for: .normal)
        self.isUserInteractionEnabled = true // enable again the user interaction
        self.layer.cornerRadius = self.cornerRadius
    }
    
    private func animateToOriginalWidth(completion:(()->Void)?) {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = (self.bounds.height)
        shrinkAnim.toValue = (self.bounds.width)
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
        
        CATransaction.commit()
    }
    
    private func shrink() {
        let shrinkAnim                   = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue             = frame.width
        shrinkAnim.toValue               = frame.height
        shrinkAnim.duration              = shrinkDuration
        shrinkAnim.timingFunction        = shrinkCurve
        shrinkAnim.fillMode              = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    private func expand(completion:(()->Void)?, revertDelay: TimeInterval) {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height/self.frame.size.height)*2
        expandAnim.fromValue            = 1.0
        expandAnim.toValue              = max(expandScale,26.0)
        expandAnim.timingFunction       = expandCurve
        expandAnim.duration             = 0.4
        expandAnim.fillMode             = .forwards
        expandAnim.isRemovedOnCompletion  = false
        
        CATransaction.setCompletionBlock {
            completion?()
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + revertDelay) {
                self.setOriginalState(completion: nil)
                self.layer.removeAllAnimations() // make sure we remove all animation
            }
        }
        
        layer.add(expandAnim, forKey: expandAnim.keyPath)
        CATransaction.commit()
    }
}

class SpinerLayer: CAShapeLayer {
    var spinnerColor = UIColor.white {
        didSet {
            strokeColor = spinnerColor.cgColor
        }
    }
    
    init(frame: CGRect) {
        super.init()
        self.setToFrame(frame)
        self.fillColor = nil
        self.strokeColor = spinnerColor.cgColor
        self.lineWidth = 1
        self.strokeEnd = 0.4
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func animation() {
        self.isHidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: .linear)
        
        rotate.repeatCount = HUGE
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        self.add(rotate, forKey: rotate.keyPath)
    }
    
    func setToFrame(_ frame: CGRect) {
        let radius:CGFloat = (frame.height / 2) * 0.5
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let center = CGPoint(x: frame.height / 2, y: bounds.center.y)
        let startAngle = 0 - Double.pi/2
        let endAngle = Double.pi * 2 - Double.pi/2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
    }
    
    func stopAnimation() {
        self.isHidden = true
        self.removeAllAnimations()
    }
}

extension UIButton {
    func defaultStyle(title:String, font:UIFont, cornerRadius:CGFloat){
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .selected)
    }
}
