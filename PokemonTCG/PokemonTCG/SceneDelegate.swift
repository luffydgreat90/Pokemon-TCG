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
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }


}

