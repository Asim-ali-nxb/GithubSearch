//
//  RepositoryListSearch.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import Combine

protocol RepositoryListSearch {
    var dataItems: CurrentValueSubject <[RepositoryListPresenter], Never>{get}
    var view: View? {get set}
    func search(query: String)
    func abort()
}

final class RepositoryListSearchConcrete: RepositoryListSearch {
    var dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>
    var view: View?
    private let dataSource: GithubSearchRepository
    private var cancellable: Cancellable?
    private var query: String?
    var totalPostsCount = 0
    
    // MARK: - Init
    init(dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>, dataSource: GithubSearchRepository) {
        self.dataItems = dataItems
        self.dataSource = dataSource
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func abort() {
        cancellable?.cancelRequest()
        cancellable = nil
        dataItems.send([])
        totalPostsCount = 0
        query = nil
    }
    
    func search(query: String) {
        self.query = query
        cancellable?.cancelRequest()
        cancellable = dataSource.searchRepos(query: query, response: {[weak self] response in
            switch response {
            case .success(let successResponse):
                self?.view?.loadingActivity(loading: false)
                let repos = successResponse.map {repo in
                    RepositoryListPresenter(id: repo.id, name: repo.name, fullName: repo.fullName, repositoryURL: repo.url)
                }
                self?.dataItems.send(repos)
                
            case .failure(let error):
                if(!((error as NSError).domain == "NSURLErrorDomain" && (error as NSError).code == -999)) {
                    self?.view?.showError(title: "Error", message: error.localizedDescription)
                }
            }
        })
    }
}
