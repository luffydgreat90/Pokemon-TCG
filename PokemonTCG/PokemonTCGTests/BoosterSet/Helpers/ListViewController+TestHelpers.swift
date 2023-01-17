//
//  ListViewController+TestHelpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit
import PokemoniOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateTapOnBoosterSet(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: boosterSetsSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

extension ListViewController {
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func numberOfRenderedBoosterSetViews() -> Int {
        numberOfRows(in: boosterSetsSection)
    }
    
    func boosterSetView(at row: Int) -> UITableViewCell? {
        cell(row: row, section: boosterSetsSection)
    }
    
    @discardableResult
    func simulateBoosterSetViewVisible(at index: Int) -> BoosterSetCell? {
        return boosterSetView(at: index) as? BoosterSetCell
    }
    
    @discardableResult
    func simulateBoosterSetViewNotVisible(at row: Int) -> BoosterSetCell? {
        let view = simulateBoosterSetViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: boosterSetsSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }
    
    @discardableResult
    func simulateBoosterSetViewBecomingVisibleAgain(at row: Int) -> BoosterSetCell? {
        let view = simulateBoosterSetViewNotVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: boosterSetsSection)
        delegate?.tableView?(tableView, willDisplay: view!, forRowAt: index)

        return view
    }
    
    func simulateBoosterSetViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: boosterSetsSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateBoosterSetViewNotNearVisible(at row: Int) {
        simulateBoosterSetViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: boosterSetsSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateLoadMoreAction() {
        guard let view = loadMoreCell() else { return }
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: loadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }
    
    func simulateTapOnLoadMoreError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: loadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    var isShowingLoadMoreIndicator: Bool {
        return loadMoreCell()?.isLoading == true
    }

    private func loadMoreCell() -> LoadMoreCell? {
           cell(row: 0, section: loadMoreSection) as? LoadMoreCell
       }
    
    @discardableResult
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateBoosterSetViewVisible(at: index)?.renderedImage
    }
    
    var loadMoreFeedErrorMessage: String? {
        return loadMoreCell()?.message
    }
    
    private var boosterSetsSection: Int { 0 }
    private var loadMoreSection: Int { 1 }
}
