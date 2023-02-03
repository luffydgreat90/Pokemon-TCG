//
//  DeckViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 2/2/23.
//

import UIKit
import PokemonFeed

class DeckController: NSObject {
    private let viewModel: DeckViewModel
    private var cell: DeckCell?
    private let selection: () -> Void
    
    public init(viewModel: DeckViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension DeckController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.titleLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.update
        return cell!
    }
}

extension DeckController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
}
