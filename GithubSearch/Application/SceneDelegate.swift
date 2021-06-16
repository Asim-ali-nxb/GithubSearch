//
//  SceneDelegate.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var app: GithubSearchApp?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let parser = ParseManager()
        let factory = iOSViewControllerFactory(baseURL: URL(string: "https://api.github.com/search")!, parser: parser)
        let navigationController = UINavigationController()
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let repositoryListFlow = FlowRepositoryList(delegate: RepositoryListNavigationControllerRouter(navigationController: navigationController, factory: factory))
        
        app = GithubSearchApp.start(flow: repositoryListFlow)
    }
}

