//
//  UITableView+HeaderSizing.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/9/23.
//

import UIKit.UITableView

extension UITableView{
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }

        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
