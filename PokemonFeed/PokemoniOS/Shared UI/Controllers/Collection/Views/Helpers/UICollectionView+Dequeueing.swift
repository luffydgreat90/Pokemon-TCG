//
//  UICollectionView+Dequeueing.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/4/23.
//

import UIKit.UICollectionView

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath:IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
