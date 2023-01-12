//
//  UIImage+StaticImage.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/12/23.
//

import UIKit

extension UIImage {
    static func placeholder(type: AnyObject.Type) -> UIImage {
        UIImage(named: "placeHolderImage", in: Bundle(for: type), with: nil)!
    }
}
