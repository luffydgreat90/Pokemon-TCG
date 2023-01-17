//
//  BoosterSetAcceptanceTests.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import XCTest
import UIKit
import PokemoniOS
import PokemonFeed
@testable import PokemonTCG

class BoosterSetAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        
        let feed = launch(httpClient: .online(response), boosterSetStore: .empty)
    
        XCTAssertEqual(feed.numberOfRenderedBoosterSetViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData())
        
//        feed.simulateLoadMoreAction()
//        XCTAssertEqual(feed.numberOfRenderedBoosterSetViews(), 3)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryBoosterSetStore.empty
        let onlineFeed = launch(httpClient: .online(response), boosterSetStore: sharedStore)
        onlineFeed.renderedFeedImageData(at: 0)
        onlineFeed.renderedFeedImageData(at: 1)

        let offlineFeed = launch(httpClient: .offline, boosterSetStore: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedBoosterSetViews(), 2)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, boosterSetStore: .empty)

        XCTAssertEqual(feed.numberOfRenderedBoosterSetViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() throws {
        let store = InMemoryBoosterSetStore.withExpiredFeedCache
        try enterBackground(with: store)
        XCTAssertNil(store.boosterSetCache, "Expected to delete expired cache")
    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub = .offline,
        boosterSetStore: InMemoryBoosterSetStore = .empty
    ) -> ListViewController {
       
        let sut = SceneDelegate(httpClient: httpClient, boosterSetStore: boosterSetStore)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with boosterSetStore: InMemoryBoosterSetStore) throws {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, boosterSetStore: boosterSetStore)

        let sceneClass = NSClassFromString("UIScene") as? NSObject.Type
        let scene = try XCTUnwrap(sceneClass?.init() as? UIScene)
        sut.sceneWillResignActive(scene)
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
            case "/image-1", "/image-2", "/image-3":
                return makeImageData()
            case "/v2/sets":
                return makeBoosterSet()
            default:
                return Data()
        }
    }
    
    
    private func makeBoosterSet() -> Data {
        return """
        {
        "data": [
            {
                "id": "base1",
                "name": "Base",
                "series": "Base",
                "printedTotal": 102,
                "total": 102,
                "legalities": {
                    "unlimited": "Legal"
                },
                "ptcgoCode": "BS",
                "releaseDate": "1999/01/09",
                "updatedAt": "2022/10/10 15:12:00",
                "images": {
                    "symbol": "http://feed.com/image-1",
                    "logo": "https://images.pokemontcg.io/base1/logo.png"
                }
            },
            {
                "id": "base2",
                "name": "Jungle",
                "series": "Base",
                "printedTotal": 64,
                "total": 64,
                "legalities": {
                    "unlimited": "Legal"
                },
                "ptcgoCode": "JU",
                "releaseDate": "1999/06/16",
                "updatedAt": "2020/08/14 09:35:00",
                "images": {
                    "symbol": "http://feed.com/image-2",
                    "logo": "https://images.pokemontcg.io/base2/logo.png"
        
                }
            }
         ]
        }
        """.data(using: .utf8)!
    }
    
    private func makeBoosterSetLoadMore() -> Data {
        return """
        {
        "data": [
            {
                "id": "base3",
                "name": "Base",
                "series": "Base",
                "printedTotal": 102,
                "total": 102,
                "legalities": {
                    "unlimited": "Legal"
                },
                "ptcgoCode": "BS",
                "releaseDate": "1999/01/09",
                "updatedAt": "2022/10/10 15:12:00",
                "images": {
                    "symbol": "http://feed.com/image-3",
                    "logo": "https://images.pokemontcg.io/base1/logo.png"
                }
            }
         ]
        }
        """.data(using: .utf8)!
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
}
