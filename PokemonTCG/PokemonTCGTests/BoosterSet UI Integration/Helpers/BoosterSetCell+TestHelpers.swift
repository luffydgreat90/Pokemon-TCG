//
//  BoosterSetCell+TestHelpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit
import PokemoniOS

extension BoosterSetCell {
    var titleText: String? {
        titleLabel.text
    }
    
    var totalCardsText: String? {
        numberLabel.text
    }
    
    var releaseDateText: String? {
        releaseDateLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return containerImageView.isShimmering
    }
    
    var renderedImage: Data? {
        return boosterSetImageView.image?.pngData()
    }
}
