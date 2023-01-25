//
//  CardDetailViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/25/23.
//

import UIKit
import PokemonFeed

public class CardDetailViewController: UIViewController {
    public typealias ResourceViewModel = UIImage
    private let customView: CardDetailView = CardDetailView()
    public var loadImage: (() -> Void)?
    public var openUrl: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = customView
        loadImage?()
    }
    
    public func displayCardDetail(_ viewModel: CardDetailViewModel){
        customView.titleLabel.text = viewModel.name
        customView.numberLabel.text = viewModel.number
        customView.lowPriceLabel.text = viewModel.lowPrice
        customView.trendPriceLabel.text = viewModel.trendPrice
        customView.averageSellPriceLabel.text = viewModel.averageSellPrice
        customView.artistLabel.text = viewModel.artist
        customView.cardTypeLabel.text = viewModel.supertype
        customView.baseSetLabel.text = viewModel.baseSetName
        
        customView.cardMarketButton.addTarget(self, action: #selector(cardMarketButtonTapped), for: .touchUpInside)
    }
    
    @objc func cardMarketButtonTapped() {
        openUrl?()
    }
}

extension CardDetailViewController: ResourceView, ResourceLoadingView, ResourceErrorView {
    
    public func display(_ viewModel: UIImage) {
        customView.cardImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        customView.cardImageView.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        if viewModel.message != nil {
            
        }
    }
    
}
