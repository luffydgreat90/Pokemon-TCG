//
//  BoosterSetCell.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit

public final class BoosterSetCell: UITableViewCell {
    
    public private(set) var boosterSetImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
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
    
    public private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
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
        selectionStyle = .none
        
        addSubview(containerStack)
        containerStack.addArrangedSubview(boosterSetImageView)
        containerStack.addArrangedSubview(titleLabel)
        
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8).withPriority(999),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).withPriority(999),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            boosterSetImageView.widthAnchor.constraint(equalToConstant: 50.0),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 35.0)
        ])
    }
}
