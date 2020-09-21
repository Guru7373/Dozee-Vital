//
//  OnBoardTableViewCell.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import UIKit

class OnBoardTableViewCell: UITableViewCell {
    let cardView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        
        setupContentView()
    }
    
    private func setupContentView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
