//
//  GithubSearchRepository.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

protocol GithubSearchRepository {
    func searchRepos(query: String, page: Int, pageSize: Int, response: @escaping ((Result<RepositoryResult, Error>) -> Void)) -> Cancellable?
}
