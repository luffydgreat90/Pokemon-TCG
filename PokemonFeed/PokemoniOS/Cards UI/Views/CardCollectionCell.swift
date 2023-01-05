//
//  CardCollectionCell.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/4/23.
//

import UIKit

class CardCollectionCell: UICollectionViewCell {
    
    public private(set) var containerStack: UIStackView = {
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.alignment = .center
        return containerStack
    }()
    
    public private(set) var cardImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    public private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public private(set) var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = .black
        priceLabel.numberOfLines = 0
        priceLabel.font = .systemFont(ofSize: 14.0, weight: .light)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerStack)
        containerStack.addArrangedSubview(cardImageView)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(priceLabel)
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 4).withPriority(999),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).withPriority(999),
            
            cardImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
