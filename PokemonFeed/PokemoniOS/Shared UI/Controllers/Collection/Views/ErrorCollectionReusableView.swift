//
//  ErrorCollectionReusableView.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/12/23.
//

import UIKit

public final class ErrorCollectionView: UICollectionReusableView {
    public private(set) var errorView: ErrorView = ErrorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupUI(){
        self.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
