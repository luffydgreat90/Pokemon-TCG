//
//  DeckNewView.swift
//  PokemoniOS
//
//  Created by Marlon Von Bernales Ansale on 09/02/2023.
//

import UIKit

public class DeckNewView: UIView {
    public private(set) var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Deck Name:"
        return nameLabel
    }()
    
    public private(set) var nameText: UITextField = {
        let nameText = UITextField()
        return nameText
    }()
    
    public private(set) var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.setTitle("New Deck", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        return submitButton
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
        self.addSubviews(views: [nameLabel, nameText, submitButton])
        self.backgroundColor = .systemBackground
    }
    
    private func setupAutoLayout(){
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            nameText.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameText.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            nameText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            
            submitButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            submitButton.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 16),
        ])
    }
}
