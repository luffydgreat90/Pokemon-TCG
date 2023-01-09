//
//  UIView+Container.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/9/23.
//

import UIKit.UIView

extension UIView {
    public func makeContainer() -> UIView {
        let container = UIView()
        container.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        return container
    }
}
