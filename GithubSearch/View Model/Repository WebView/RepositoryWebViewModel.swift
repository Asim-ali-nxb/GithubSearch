//
//  RepositoryWebViewModel.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import Combine

protocol RepositoryWebViewModel {
    var repoURL: PassthroughSubject <URLRequest, Never>{get}
    var repoTitle: CurrentValueSubject <String, Never>{get}
    var view: View? {get set}
    func load()
}

final class RepositoryWebViewModelConcrete: RepositoryWebViewModel {
    var view: View?
    var repoURL: PassthroughSubject<URLRequest, Never> = PassthroughSubject<URLRequest, Never>()
    var repoTitle: CurrentValueSubject <String, Never> = CurrentValueSubject("")
    
    private let url: URL
    private let title: String
    
    // MARK: - Init
    init(url: URL, title: String) {
        self.url = url
        self.title = title
    }
    
    func load() {
        self.view?.loadingActivity(loading: true)
        let request = URLRequest(url: url)
        repoURL.send(request)
        repoTitle.send(title)
    }
}
