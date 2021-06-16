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
    func searchMore()
    func abort()
}

final class RepositoryListSearchConcrete: RepositoryListSearch {
    var dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>
    var view: View?
    private let dataSource: GithubSearchRepository
    private var cancellable: Cancellable?
    private var query: String?
    private let pageSize = 30
    var totalCount = 0
    
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
        totalCount = 0
        query = nil
    }
    
    func search(query: String) {
        dataItems.value = []
        search(query: query, page: 1)
    }
    
    func searchMore() {
        if let query = query {
            let currentCount = (dataItems.value.count / pageSize) + 1
            if(dataItems.value.count < totalCount) {
                self.view?.loadingActivity(loading: true)
                search(query: query, page: currentCount)
            }
        }
    }
    
    func search(query: String, page: Int = 0) {
        self.query = query
        cancellable?.cancelRequest()
        cancellable = dataSource.searchRepos(query: query, page: page, pageSize: pageSize, response: {[weak self] response in
            switch response {
            case .success(let successResponse):
                self?.view?.loadingActivity(loading: false)
                self?.totalCount = successResponse.totalCount
                
                var repos: [RepositoryListPresenter] = self?.dataItems.value ?? []
                
                let newRepos = successResponse.items.map {repo in
                    RepositoryListPresenter(name: repo.name, fullName: repo.fullName, repositoryURL: repo.url)
                }
                
                repos.append(contentsOf: newRepos)
                
                self?.dataItems.send(repos)
                
            case .failure(let error):
                if(!((error as NSError).domain == "NSURLErrorDomain")) {
                    self?.view?.showError(title: "Error", message: error.localizedDescription)
                }
            }
        })
    }
}
