//
//  DeckNewViewController.swift
//  PokemoniOS
//
//  Created by Marlon Von Bernales Ansale on 13/02/2023.
//

import UIKit

class DeckNewViewController: UIViewController {
    private let customView: DeckNewView = DeckNewView()
    public var newDeck: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = customView

        customView.submitButton.addTarget(self, action: #selector(deckButtonTapped), for: .touchUpInside)
    }

    @objc private func deckButtonTapped() {
        guard let name = customView.nameText.text else {
            return
        }

        newDeck?(name)
    }
}
