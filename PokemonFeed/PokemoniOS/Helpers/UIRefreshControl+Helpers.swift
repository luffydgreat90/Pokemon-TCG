//
//  UIRefreshControl+Helpers.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/8/23.
//

import UIKit.UIRefreshControl

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
