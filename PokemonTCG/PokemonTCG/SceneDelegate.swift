//
//  SceneDelegate.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import Combine
import CoreData
import PokemonFeed
import PokemoniOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var baseURL = URL(string: "https://api.pokemontcg.io/v2/")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: BoosterSetStore & ImageDataStore = {
        try! CoreDataBoosterSetStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("booster-set-store.sqlite"))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(rootViewController: makeBoosterSetsViewController())
        window?.makeKeyAndVisible()
        
    }

    private func makeBoosterSetsViewController() -> ListViewController {
        return BoosterSetsUIComposer.boosterSetsComposedWith(
            boosterSetsLoader: makeRemoteBoosterSetsLoader,
            imageLoader: makeLImageLoader)
    }
    
    private func makeRemoteBoosterSetsLoader() -> AnyPublisher<[BoosterSet], Error> {
        let url = BoosterSetsEndPoint.get.url(baseURL: baseURL)

        return httpClient
            .getPublisher(url: url)
            .tryMap(BoosterSetsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeLImageLoader(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalBoosterSetImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                httpClient
                    .getPublisher(url: url)
                    .tryMap(ImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
}

