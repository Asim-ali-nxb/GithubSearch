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
    func loadMore()
}

final class RepositoryListConcreteViewModel: RepositoryListViewModel {
    let searchPlaceholder: String = "Search Github Repositories"
    let dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>
    private let dataSource: GithubSearchRepository
    private var networkNotifier: NetworkNotifier
    
    weak var view: View? {
        didSet {
            searchViewModel.view = view
        }
    }
    var searchText = CurrentValueSubject<String, Never>("")
    var cancellable: Cancellable?
    private var searchViewModel: RepositoryListSearch
    var subscription: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(dataItems: CurrentValueSubject<[RepositoryListPresenter], Never>,
         dataSource: GithubSearchRepository,
         searchViewModel: RepositoryListSearch,
         networkNotifier: NetworkNotifier) {
        self.dataSource = dataSource
        self.searchViewModel = searchViewModel
        self.dataItems = dataItems
        self.networkNotifier = networkNotifier
        searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .dropFirst(1)
            .map({[unowned self] (string) -> String? in
                if string.count < 1 {
                    self.searchViewModel.abort()
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
                self.searchViewModel.search(query: searchField)
            }.store(in: &subscription)
        
        self.networkNotifier.whenReachable = onNetworkReachale
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func loadMore() {
        searchViewModel.searchMore()
    }

    func onNetworkReachale() {
    }
    
    func onNetworkUnreachable() {
        view?.showError(title: "Error", message: "Internet not available")
        self.networkNotifier.whenUnreachable = onNetworkUnreachable
    }
}
