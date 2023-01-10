//
//  BoosterSetCell.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit

public final class BoosterSetCell: UITableViewCell {
    
    private var containerImageView: UIView = {
        let containerImageView = UIView()
        containerImageView.translatesAutoresizingMaskIntoConstraints = false
        containerImageView.layer.cornerRadius = 24
        containerImageView.layer.masksToBounds = true
        containerImageView.clipsToBounds = true
        containerImageView.backgroundColor = .cellImageViewBackground
        return containerImageView
    }()
    
    public private(set) var boosterSetImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
       
        return imageView
    }()
    
    public private(set) var containerStack: UIStackView = {
        let containerStack = UIStackView()
        containerStack.layer.masksToBounds = true
        containerStack.layer.cornerRadius = 8.0
        containerStack.spacing = 8
        containerStack.axis = .horizontal
        containerStack.clipsToBounds = true
        containerStack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.isLayoutMarginsRelativeArrangement = true
        return containerStack
    }()
    
    private var containerDetailsView: UIView = {
        let containerDetailsView = UIView()
        containerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        return containerDetailsView
    }()
    
    public private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public private(set) var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textColor = .label
        numberLabel.numberOfLines = 0
        numberLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    public private(set) var releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel()
        releaseDateLabel.textColor = .label
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return releaseDateLabel
    }()
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessibilityIdentifier = reuseIdentifier
        setupUI()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerStack)
        containerStack.addArrangedSubview(containerImageView)
        containerStack.addArrangedSubview(containerDetailsView)
        
        containerImageView.addSubview(boosterSetImageView)
        containerDetailsView.addSubviews(views: [titleLabel,numberLabel, releaseDateLabel])

    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8).withPriority(999),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).withPriority(999),
            
            containerImageView.widthAnchor.constraint(equalToConstant: 80.0),
            containerImageView.heightAnchor.constraint(equalToConstant: 80.0),
            
            boosterSetImageView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor, constant: 8),
            boosterSetImageView.trailingAnchor.constraint(equalTo: containerImageView.trailingAnchor, constant: -8),
            boosterSetImageView.topAnchor.constraint(equalTo: containerImageView.topAnchor, constant: 8),
            boosterSetImageView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerDetailsView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerDetailsView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerDetailsView.trailingAnchor, constant: -8),
            
            numberLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            numberLabel.leadingAnchor.constraint(equalTo: containerDetailsView.leadingAnchor, constant: 8),
            numberLabel.trailingAnchor.constraint(equalTo: containerDetailsView.trailingAnchor, constant: -8),
            
            releaseDateLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            releaseDateLabel.leadingAnchor.constraint(equalTo: containerDetailsView.leadingAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: containerDetailsView.trailingAnchor, constant: -8)
        ])
    }
}


