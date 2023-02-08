//
//  DeckCell.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 2/3/23.
//

import UIKit
import PokemonFeed

public class DeckCell: UITableViewCell {
    public private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public private(set) var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .label
        dateLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
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
        contentView.addSubviews(views: [titleLabel, dateLabel])
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).withPriority(999),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).withPriority(999),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).withPriority(999),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).withPriority(999),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).withPriority(999),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).withPriority(999),
        ])
    }
}
