//
//  BoosterSetUIIntegrationTests.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import XCTest
import UIKit
import PokemonTCG
import PokemonFeed
import PokemoniOS
import Combine

class BoosterSetUIIntegrationTests: XCTestCase {
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, boosterSetsTitle)
    }
    
    func test_boosterSetSelection_notifiesHandler() {
        let boosterSet1 = makeBoosterSet()
        let boosterSet2 = makeBoosterSet()
        var selectedImages = [BoosterSet]()
        
        let (sut, loader) = makeSUT(selection: { selectedImages.append($0) })

        sut.loadViewIfNeeded()
        loader.completeBoosterSetLoading(with: [boosterSet1, boosterSet2], at: 0)

        sut.simulateTapOnFeedImage(at: 0)
        XCTAssertEqual(selectedImages, [boosterSet1])

        sut.simulateTapOnFeedImage(at: 1)
        XCTAssertEqual(selectedImages, [boosterSet1, boosterSet2])
    }
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingListIndicator_isVisibleWhileLoadingBoosterSet() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeBoosterSetLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeBoosterSetLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadBoosterSetCompletion_rendersSuccessfullyLoadedBoosterSet() {
        let boosterSet0 = makeBoosterSet()
        let boosterSet1 = makeBoosterSet()
        let boosterSet2 = makeBoosterSet()
        let boosterSet3 = makeBoosterSet()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeBoosterSetLoading(with: [boosterSet0], at: 0)
        assertThat(sut, isRendering: [boosterSet0])
        
        sut.simulateUserInitiatedReload()
        loader.completeBoosterSetLoading(with: [boosterSet0, boosterSet1, boosterSet2, boosterSet3], at: 1)
        assertThat(sut, isRendering: [boosterSet0, boosterSet1, boosterSet2, boosterSet3])
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyBoosterSetAfterNonEmptyBoosterSet() {
        let boosterSet0 = makeBoosterSet()
        let boosterSet1 = makeBoosterSet()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBoosterSetLoading(with: [boosterSet0, boosterSet1], at: 0)
        assertThat(sut, isRendering: [boosterSet0, boosterSet1])

        sut.simulateUserInitiatedReload()
        loader.completeBoosterSetLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }
    
    func test_loadBoosterSetCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let boosterSet0 = makeBoosterSet()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBoosterSetLoading(with: [boosterSet0], at: 0)
        assertThat(sut, isRendering: [boosterSet0])

        sut.simulateUserInitiatedReload()
        loader.completeBoosterSetLoadingWithError(at: 1)
        assertThat(sut, isRendering: [boosterSet0])
    }
    
    func test_loadBoosterSetCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeBoosterSetLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadBoosterSetCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeBoosterSetLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeBoosterSetLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)

        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    // MARK: - Image View Tests

    func test_boosterSetImageView_loadsImageURLWhenVisible() {
        let boosterSet0 = makeBoosterSet(symbol: URL(string: "http://url-0.com")!)
        let boosterSet1 = makeBoosterSet(symbol: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBoosterSetLoading(with: [boosterSet0, boosterSet1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateBoosterSetViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [boosterSet0.images.symbol], "Expected first image URL request once first view becomes visible")

        sut.simulateBoosterSetViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [boosterSet0.images.symbol, boosterSet1.images.symbol], "Expected second image URL request once second view also becomes visible")
    }
    
    // MARK: - Helpers

    private func makeSUT(
        selection: @escaping (BoosterSet) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BoosterSetsUIComposer.boosterSetsComposedWith(
            boosterSetsLoader: loader.loadPublisher,
            imageLoader: loader.loadImageDataPublisher(from:),
            selection: selection)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    func makeBoosterSet(symbol:URL = anyURL()) -> BoosterSet {
        let id = UUID().uuidString
        return BoosterSet(
            id: id,
            name: "Booster \(id)",
            series: "Series \(id)",
            printedTotal: 1,
            total: 1,
            legalities: Legalities(isUnlimited: true, isStandard: true, isExpanded: true),
            releaseDate: Date(),
            images: BoosterImage(symbol: symbol, logo: anyURL()))
    }
    
}
