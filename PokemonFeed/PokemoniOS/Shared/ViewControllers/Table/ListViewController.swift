//
//  ListViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import PokemonFeed

public final class ListViewController: UITableViewController {
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
    }()
    
    public var onRefresh: (() -> Void)?
    public var configureTableView: ((UITableView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        onRefresh?()
    }
    
    private func setupUI(){
        refreshControl = UIRefreshControl(frame: .zero)
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = self
        configureTableView?(tableView)
    }
    
    public func display(_ cellControllers: [CellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    private func controller(for indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dsp = controller(for: indexPath)?.delegate
        dsp?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(for: indexPath)?.dataSourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(for: indexPath)?.dataSourcePrefetching
            dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }
}

extension ListViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}

extension ListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        
    }
}
