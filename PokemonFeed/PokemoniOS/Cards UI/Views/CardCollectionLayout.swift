//
//  CardCollectionLayout.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit

public final class CardCollectionLayout: UICollectionViewFlowLayout {
    public override init() {
        super.init()
        self.itemSize = CGSize(width: 110, height: 200)
        self.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        self.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
