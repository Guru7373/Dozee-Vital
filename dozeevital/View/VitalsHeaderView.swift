//
//  VitalsHeaderView.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import UIKit

class VitalsHeaderView: UICollectionViewCell {
    let cardView = UIView()
    let iconView = UIImageView()
    let greetingLabel = UILabel()
    let freshBtn = UIButton()
    let goodBtn = UIButton()
    let tiredBtn = UIButton()
    let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(greetingLabel)
        cardView.addSubview(freshBtn)
        cardView.addSubview(goodBtn)
        cardView.addSubview(tiredBtn)
                
        setupViews()        
    }
    
    func addGradientBackground() {
        cardView.clipsToBounds = true
        gradientLayer.colors = [UIColor(hexString: "#050645").cgColor, UIColor(hexString: "#595BAE").cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    fileprivate func setupViews() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        freshBtn.translatesAutoresizingMaskIntoConstraints = false
        goodBtn.translatesAutoresizingMaskIntoConstraints = false
        tiredBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 16),
            iconView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -20),
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            freshBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            freshBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            freshBtn.widthAnchor.constraint(equalToConstant: 60),
            freshBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            goodBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            goodBtn.leadingAnchor.constraint(equalTo: freshBtn.trailingAnchor, constant: 8),
//            goodBtn.widthAnchor.constraint(equalToConstant: 60),
            goodBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tiredBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            tiredBtn.leadingAnchor.constraint(equalTo: goodBtn.trailingAnchor, constant: 8),
//            tiredBtn.widthAnchor.constraint(equalToConstant: 60),
            tiredBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
