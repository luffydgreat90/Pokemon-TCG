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
    
    private lazy var baseURL = URL(string: "https://api.pokemontcg.io")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.pokemontcg.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var boosterSetStore: BoosterSetStore & ImageDataStore = {
        try! CoreDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("booster-set-store.sqlite"),
            store: CoreDataBoosterSetStore.self)
    }()
    
    private lazy var cardStore: CardStore & ImageDataStore = {
        try! CoreDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("card-set-store.sqlite"),
            store: CoreDataCardStore.self)
    }()
    
    private lazy var localBoosterSetLoader: LocalBoosterSetLoader = {
        LocalBoosterSetLoader(store: boosterSetStore, currentDate: Date.init)
    }()
    
    private lazy var localCardLoader: LocalCardLoader = {
        LocalCardLoader(store: cardStore, currentDate: Date.init)
    }()
    
    private lazy var navigationController: UINavigationController = {
        UINavigationController(rootViewController: makeBoosterSetsViewController())
    }()
    
    convenience init(httpClient: HTTPClient, boosterSetStore: BoosterSetStore & ImageDataStore, scheduler: AnyDispatchQueueScheduler) {
        self.init()
        self.httpClient = httpClient
        self.boosterSetStore = boosterSetStore
        self.scheduler = scheduler
    }
    
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
            boosterSetsLoader: makeRemoteBoosterSetsLoaderWithLocalFallback,
            imageLoader: makeBoosterSetImageLoader,
            selection: showCard)
    }
    
    private func makeRemoteBoosterSetsLoaderWithLocalFallback() -> AnyPublisher<Paginated<BoosterSet>, Error> {
        return makeRemoteBoosterSetsLoader()
            .caching(to: localBoosterSetLoader)
            .fallback(to: localBoosterSetLoader.loadPublisher)
            .map(makeFirstPage)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteBoosterSetsLoader(totalItems:Int = 0) -> AnyPublisher<[BoosterSet], Error> {
        let url = BoosterSetsEndPoint.get(totalItems: totalItems).url(baseURL: baseURL)
        return httpClient
            .getPublisher(url: url)
            .tryMap(BoosterSetsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [BoosterSet]) -> Paginated<BoosterSet> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [BoosterSet], last: BoosterSet?) -> Paginated<BoosterSet> {
        return Paginated(items: items, loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(totalItems:items.count) }
        })
    }

    private func makeRemoteLoadMoreLoader(totalItems:Int) -> AnyPublisher<Paginated<BoosterSet>, Error> {
        localBoosterSetLoader.loadPublisher()
            .zip(makeRemoteBoosterSetsLoader(totalItems: totalItems))
            .map { (cachedItems, newItems) in
                (cachedItems + newItems, newItems.last)
            }.map(makePage)
            .caching(to: localBoosterSetLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func showCard(for boosterSet: BoosterSet) {
        let url = CardEndPoint.get(boosterSet.id).url(baseURL: baseURL)
        let viewController = CardListUIComposer.cardListComposedWith(
            cardList: makeRemoteCardsLoader(url: url, setId: boosterSet.id),
            imageLoader: makeCardImageLoader(url:))
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeBoosterSetImageLoader(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalImageDataLoader(store: boosterSetStore)
        return makeImageLoader(withURL: url, localImageLoader: localImageLoader)
    }
    
    private func makeCardImageLoader(url:URL?) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalImageDataLoader(store: cardStore)
        return makeImageLoader(withURL: url, localImageLoader: localImageLoader)
    }
    
    private func makeImageLoader(withURL url:URL?, localImageLoader: LocalImageDataLoader) -> AnyPublisher<Data, Error> {
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient, scheduler] in
                return httpClient
                    .getPublisher(url: url)
                    .tryMap(ImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteCardsLoader(url: URL, setId:String) -> () -> AnyPublisher<[Card], Error> {
        return {  [httpClient, localCardLoader, scheduler] in
            httpClient
            .getPublisher(url: url)
            .tryMap(CardMapper.map)
            .caching(to: localCardLoader, setId: setId)
            .fallback(to: {
                return localCardLoader.loadPublisher(setId: setId)
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
        }
    }
}

