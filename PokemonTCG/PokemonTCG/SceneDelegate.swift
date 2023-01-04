//
//  SceneDelegate.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var baseURL = URL(string: "https://api.pokemontcg.io/v2/")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
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
        return httpClient
            .getPublisher(url: url)
            .tryMap(ImageDataMapper.map)
            .eraseToAnyPublisher()
    }
}

