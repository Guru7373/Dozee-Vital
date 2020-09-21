//
//  VitalsCollectionViewCell.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import UIKit

class VitalsCollectionViewCell: UICollectionViewCell {
    let cardView = UIView()
    let rightArrow = UIImageView()
    let rateLabel = UILabel()
    let unitLabel = UILabel()
    let symbolView = UIImageView()
    let indicator = UILabel()
    
    let upArrow = UIImageView(image: #imageLiteral(resourceName: "UpFilled"))
    let downArrow = UIImageView(image: #imageLiteral(resourceName: "DownFilled"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cardView)
        cardView.addSubview(rightArrow)
        cardView.addSubview(rateLabel)
        cardView.addSubview(unitLabel)
        cardView.addSubview(symbolView)
        cardView.addSubview(indicator)
        
        rateLabel.textColor = .white
        
        cardView.addSubview(upArrow)
        upArrow.isHidden = true
        
        cardView.addSubview(downArrow)
        downArrow.isHidden = true
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        upArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightArrow.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            rightArrow.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -20),
            rightArrow.widthAnchor.constraint(equalToConstant: 6),
            rightArrow.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            rateLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor, constant: 5),
            rateLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            unitLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 0),
            unitLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            symbolView.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: -5),
            symbolView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            symbolView.widthAnchor.constraint(equalToConstant: 30),
            symbolView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            indicator.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            upArrow.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor, constant: -10),
            upArrow.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor, constant: -16),
            upArrow.widthAnchor.constraint(equalToConstant: 10),
            upArrow.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            downArrow.topAnchor.constraint(equalTo: upArrow.bottomAnchor, constant: 25),
            downArrow.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor, constant: -16),
            downArrow.widthAnchor.constraint(equalToConstant: 10),
            downArrow.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
