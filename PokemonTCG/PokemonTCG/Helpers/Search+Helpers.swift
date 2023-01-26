//
//  Search+Helpers.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/26/23.
//

import UIKit.UITextField
import Combine

public extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
         NotificationCenter.default.publisher(
             for: UITextField.textDidChangeNotification,
             object: self
         )
         .compactMap { ($0.object as? UITextField)?.text }
         .eraseToAnyPublisher()
     }
}
