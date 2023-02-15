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
    
    private lazy var tabBarController = TabBarController()
    
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
    
    private lazy var cardStore: CardStore & ImageDataStore & DeckStore = {
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
    
    private lazy var localDeckLoader: LocalDeckLoader  = {
        LocalDeckLoader(store: cardStore, currentDate: Date.init)
    }()
    
    private lazy var priceFormatter: NumberFormatter = {
        .priceFormatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        .monthDayYear
    }()
    
    private lazy var rootController: UIViewController = {
        tabBarController.displayTab(with: [navigationBoosterSet, navigationDeck])
        return tabBarController
    }()
    
    private lazy var applicationShared = UIApplication.shared
    
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
        do {
            try localBoosterSetLoader.validateCache()
        }catch {
            debugPrint("Failed to validate cache with error: \(error.localizedDescription)")
        }
    }
    
    func configureWindow() {
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
    
    private lazy var navigationBoosterSet: UINavigationController = {
        UINavigationController(
            rootViewController: BoosterSetsUIComposer.boosterSetsComposedWith(
                boosterSetsLoader: makeRemoteBoosterSetsLoaderWithLocalFallback,
                imageLoader: makeBoosterSetImageLoader,
                selection: showCards))
    }()
    
    
    private lazy var navigationDeck: UINavigationController = {
        
        let viewController = DeckUIComposer.cardDeckComposedWith(
            decksLoader: makeDeckLoader,
            newDeck: showNewDeck,
            selection: { _ in
                
            })
        
        return UINavigationController(
        rootViewController: viewController
        )
    }()
    
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
    
    private func makeDeckLoader() -> AnyPublisher<[Deck], Error> {
        return localDeckLoader
            .loadPublisher()
    }
    
    private func makeFirstPage(items: [BoosterSet]) -> Paginated<BoosterSet> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [BoosterSet], last: BoosterSet?) -> Paginated<BoosterSet> {
        return Paginated(items: items, loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(totalItems:items.count) }
        })
    }

    private func makeDeck(name: String) throws {
        try localDeckLoader.save(name)
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
    
    private func showNewDeck() {
        let viewController = DeckNewUIComposer.newDeckComposed(
            newDeck: { [navigationDeck, localDeckLoader] name in
                do {
                    try localDeckLoader.save(name)
                    
                    guard let listView = navigationDeck.viewControllers.first as? ListViewController else{
                        return
                    }
                    
                    listView.onRefresh?()
                } catch {}
        })
        navigationDeck.present(viewController, animated: true)
    }
    
    private func showCards(for boosterSet: BoosterSet) {
        let url = CardEndPoint.get(boosterSet.id).url(baseURL: baseURL)
        let viewController = CardListUIComposer.cardListComposedWith(
            cardList: makeRemoteCardsLoader(url: url, setId: boosterSet.id),
            imageLoader: makeCardImageLoader(url:),
            priceFormatter: priceFormatter,
            selection: showCardDetail(for:))
        
        navigationBoosterSet.pushViewController(viewController, animated: true)
    }
    
    private func showCardDetail(for card: Card) {
        let viewController = CardDetailUIComposer.cardDetailComposedWith(
            card: card,
            imageLoader: makeCardImageLoader(url:),
            openURL: openURL(url:),
            priceFormatter: priceFormatter)
        
        navigationBoosterSet.present(viewController, animated: true)
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
    
    private func openURL(url: URL?){
        guard let url =  url else{ return }
        applicationShared.open(url)
    }
}

