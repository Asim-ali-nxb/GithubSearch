//
//  GithubSearchRepository.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

public protocol GithubSearchRepository {
    func searchRepos(query: String, response: @escaping ((Result<[RepositoryModel], Error>) -> Void)) -> Cancellable?
}
