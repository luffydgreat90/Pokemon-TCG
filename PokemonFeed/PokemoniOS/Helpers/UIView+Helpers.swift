//
//  UIView+Helpers.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/5/23.
//

import UIKit.UIView

public extension UIView {
    func addSubviews(views:[UIView]){
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
}
