//
//  RepositoryListDelegate.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import UIKit

public protocol RepositoryListDelegate {
    func loadListViewController(selectionCallBack:@escaping ItemSelection)
    func loadWebViewController(withURL url: URL, title: String)
}

final class RepositoryListNavigationControllerRouter: NavigationControllerRouter, RepositoryListDelegate {
    private let factory: ViewControllerFactory
    
    // MARK: - Init
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }
    
    func loadListViewController(selectionCallBack: @escaping ItemSelection) {
        show(viewController: factory.repositoryListViewController(selectionCallback: selectionCallBack))
    }
    
    func loadWebViewController(withURL url: URL, title: String) {
        show(viewController: factory.repositoryWebViewController(url: url, title: title))
    }
    
}
