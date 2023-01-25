//
//  CardDetailViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/25/23.
//

import UIKit
import PokemonFeed

public class CardDetailViewController: UIViewController {
    public typealias ResourceViewModel = CardDetailViewModel
    private let customView: CardDetailView = CardDetailView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = customView
    }
}

extension CardDetailViewController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: CardDetailViewModel) {
        
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        if viewModel.message != nil {
            
        }
    }
    
}
