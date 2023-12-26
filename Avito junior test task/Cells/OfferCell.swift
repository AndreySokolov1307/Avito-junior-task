//
//  OfferCell.swift
//  Avito junior test task
//
//  Created by Андрей Соколов on 25.12.2023.
//

import Foundation
import UIKit

class OfferCell: UICollectionViewCell {
    static let reuseIdentifier = "OfferCell"
    
    var isFirstAppereance = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.label
    
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.label
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.textColor = UIColor.label
        
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
       // imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
       // imageView.layer.cornerRadius = 25
        //imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //Без этого картинка не всегда была до конца справа
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    private func configureCell() {
        addSubview(iconImageView)
        addSubview(vStack)
        addSubview(checkMarkImageView)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(descriptionLabel)
        vStack.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            
            vStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            vStack.trailingAnchor.constraint(equalTo: checkMarkImageView.leadingAnchor, constant: -16),
            
            checkMarkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            checkMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 20),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
}
