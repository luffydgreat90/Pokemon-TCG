//
//  ImageControllerDelegate.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public protocol ImageControllerDelegate {
    
    /// Request Image.
    func didRequestImage()
    
    /// Cancel request of Image.
    func didCancelImageRequest()
}
