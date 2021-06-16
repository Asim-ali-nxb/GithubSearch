//
//  RepositoryListViewModel.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import Combine

protocol RepositoryListViewModel {
    var dataItems: CurrentValueSubject <[RepositoryListPresenter], Never>{get}
    var view: View? {get set}
    var searchText: CurrentValueSubject <String, Never>{get set}
    var searchPlaceholder: String {get}
    func searchMore()
    func abort()
}

final class RepositoryListConcreteViewModel: RepositoryListViewModel {
    let searchPlaceholder: String = "Search Github Repositories"
    let dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>
    private let dataSource: GithubSearchRepository
    private var networkNotifier: NetworkNotifier
    private var query: String?
    private let pageSize = 30
    var totalCount = 0
    
    weak var view: View?
    
    var searchText = CurrentValueSubject<String, Never>("")
    var cancellable: Cancellable?
    var subscription: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>,
         dataSource: GithubSearchRepository,
         networkNotifier: NetworkNotifier) {
        self.dataSource = dataSource
        self.dataItems = dataItems
        self.networkNotifier = networkNotifier
        searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .dropFirst(1)
            .map({[unowned self] (string) -> String? in
                if string.count < 1 {
                    self.abort()
                    self.view?.loadingActivity(loading: false)
                    return nil
                }
                
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [unowned self] (searchField) in
                self.cancellable?.cancelRequest()
                self.cancellable = nil
                self.view?.loadingActivity(loading: true)
                self.search(query: searchField)
            }.store(in: &subscription)
        
        self.networkNotifier.whenReachable = onNetworkReachale
    }
    
    func abort() {
        cancellable?.cancelRequest()
        cancellable = nil
        dataItems.send([])
        totalCount = 0
        query = nil
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
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

    func onNetworkReachale() {
    }
    
    func onNetworkUnreachable() {
        view?.showError(title: "Error", message: "Internet not available")
        self.networkNotifier.whenUnreachable = onNetworkUnreachable
    }
}
