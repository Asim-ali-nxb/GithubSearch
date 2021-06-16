//
//  iOSViewControllerFactory.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import UIKit
import Combine
import CoreData

final class iOSViewControllerFactory: ViewControllerFactory {
    
    private let parser: ParserProtocol
    private let session = URLSession.shared
    private let baseURL: URL
    
    init(baseURL: URL, parser: ParserProtocol) {
        self.parser = parser
        self.baseURL = baseURL
    }
    
    private init() {
        fatalError("Can't be initialized without parameters")
    }
    
    func repositoryListViewController(selectionCallback:@escaping ItemSelection) -> UIViewController {
        let networkService = GithubSearchNetworkService(session: session, baseURL: baseURL, parser: parser, networkNotifier: getNetworkNotifier())
       
        let dataItems = CurrentValueSubject<[RepositoryListPresenter], Never>([])
        let viewModel = RepositoryListConcreteViewModel(dataItems: dataItems, dataSource: networkService, networkNotifier: getNetworkNotifier())
        
        let controller = RepositoryListViewController(viewModel: viewModel, selection: selectionCallback)
        viewModel.view = controller
        return controller
    }
    
    func repositoryWebViewController(url: URL, title: String) -> UIViewController {
        let viewModel = RepositoryWebViewModelConcrete(url: url, title: title)
        
        let controller = RepositoryWebViewController(viewModel: viewModel)
        viewModel.view = controller
        return controller
    }
}
