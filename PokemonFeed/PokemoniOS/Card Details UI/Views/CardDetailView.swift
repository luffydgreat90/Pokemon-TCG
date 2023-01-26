//
//  CardDetailView.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/25/23.
//

import UIKit

public class CardDetailView: UIView {
    public private(set) var cardImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .cellImageViewBackground
        return imageView
    }()
    
    public private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public private(set) var lowPriceLabel: UILabel = {
        let lowPriceLabel = UILabel()
        lowPriceLabel.numberOfLines = 0
        lowPriceLabel.textAlignment = .left
        lowPriceLabel.textColor = .red
        lowPriceLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        lowPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return lowPriceLabel
    }()
    
    public private(set) var trendPriceLabel: UILabel = {
        let trendPriceLabel = UILabel()
        trendPriceLabel.numberOfLines = 0
        trendPriceLabel.textAlignment = .left
        trendPriceLabel.textColor = .black
        trendPriceLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        trendPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return trendPriceLabel
    }()
    
    public private(set) var averageSellPriceLabel: UILabel = {
        let averageSellPriceLabel = UILabel()
        averageSellPriceLabel.numberOfLines = 0
        averageSellPriceLabel.textAlignment = .left
        averageSellPriceLabel.textColor = .darkGray
        averageSellPriceLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        averageSellPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return averageSellPriceLabel
    }()
    
    public private(set) var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.numberOfLines = 0
        numberLabel.textAlignment = .left
        numberLabel.font = .systemFont(ofSize: 14.0, weight: .light)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    public private(set) var cardTypeLabel: UILabel = {
        let cardTypeLabel = UILabel()
        cardTypeLabel.numberOfLines = 0
        cardTypeLabel.textAlignment = .left
        cardTypeLabel.textColor = .black
        cardTypeLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        cardTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        return cardTypeLabel
    }()
    
    public private(set) var artistLabel: UILabel = {
        let artistLabel = UILabel()
        artistLabel.numberOfLines = 0
        artistLabel.textAlignment = .left
        artistLabel.textColor = .black
        artistLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        return artistLabel
    }()
    
    public private(set) var baseSetLabel: UILabel = {
        let baseSetLabel = UILabel()
        baseSetLabel.numberOfLines = 0
        baseSetLabel.textAlignment = .left
        baseSetLabel.textColor = .darkGray
        baseSetLabel.font = .systemFont(ofSize: 14.0, weight: .light)
        baseSetLabel.translatesAutoresizingMaskIntoConstraints = false
        return baseSetLabel
    }()
    
    public private(set) var cardMarketButton: UIButton = {
        let cardMarketButton = UIButton()
        cardMarketButton.setTitle("Card Market", for: .normal)
        cardMarketButton.backgroundColor = .black
        cardMarketButton.titleLabel?.textColor = .white
        cardMarketButton.translatesAutoresizingMaskIntoConstraints = false
        return cardMarketButton
    }()

    public private(set) var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        self.addSubview(scrollView)
        self.backgroundColor = .white
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            views: [cardImageView, titleLabel, numberLabel, lowPriceLabel, averageSellPriceLabel, trendPriceLabel, artistLabel, cardTypeLabel, baseSetLabel, cardMarketButton])
    }
    
    private func setupAutoLayout(){
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardImageView.heightAnchor.constraint(equalToConstant: 300),
            cardImageView.widthAnchor.constraint(equalToConstant: 300),
            cardImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            baseSetLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 16),
            baseSetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: baseSetLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            numberLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
        
            cardTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            cardTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            artistLabel.topAnchor.constraint(equalTo: cardTypeLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            lowPriceLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8),
            lowPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            averageSellPriceLabel.topAnchor.constraint(equalTo: lowPriceLabel.bottomAnchor),
            averageSellPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            trendPriceLabel.topAnchor.constraint(equalTo: averageSellPriceLabel.bottomAnchor),
            trendPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cardMarketButton.topAnchor.constraint(equalTo: trendPriceLabel.bottomAnchor, constant: 16),
            cardMarketButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardMarketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardMarketButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
