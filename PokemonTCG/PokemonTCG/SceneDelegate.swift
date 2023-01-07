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
    
    private lazy var boosterSetStore: BoosterSetStore & ImageDataStore = {
        try! CoreDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("booster-set-store.sqlite"),
            store: CoreDataBoosterSetStore.self)
    }()
    
    private lazy var localBoosterSetLoader: LocalBoosterSetLoader = {
        LocalBoosterSetLoader(store: boosterSetStore, currentDate: Date.init)
    }()
    
    private lazy var navigationController: UINavigationController = {
        UINavigationController(rootViewController: makeBoosterSetsViewController())
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localBoosterSetLoader.validateCache { _ in }
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    private func makeBoosterSetsViewController() -> ListViewController {
        return BoosterSetsUIComposer.boosterSetsComposedWith(
            boosterSetsLoader: makeRemoteBoosterSetsLoader,
            imageLoader: makeBoosterSetImageLoader,
            selection: showCard(for:))
    }
    
    private func makeRemoteBoosterSetsLoader() -> AnyPublisher<[BoosterSet], Error> {
        let url = BoosterSetsEndPoint.get.url(baseURL: baseURL)

        return httpClient
            .getPublisher(url: url)
            .tryMap(BoosterSetsMapper.map)
            .caching(to: localBoosterSetLoader)
            .fallback(to: localBoosterSetLoader.loadPublisher)
    }

    private func showCard(for boosterSet: BoosterSet) {
        let url = CardEndPoint.get(boosterSet.id).url(baseURL: baseURL)
        let viewController = CardListUIComposer.cardListComposedWith(
            cardList: makeRemoteCardsLoader(url: url),
            imageLoader: makeBoosterSetImageLoader(url:))
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeBoosterSetImageLoader(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalImageDataLoader(store: boosterSetStore)
     
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                return httpClient
                    .getPublisher(url: url)
                    .tryMap(ImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
    
    private func makeRemoteCardsLoader(url: URL) -> () -> AnyPublisher<[Card], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(CardMapper.map)
                .eraseToAnyPublisher()
        }
    }
}

