//
//  GithubSearchNetworkService.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

final class GithubSearchNetworkService: Service, GithubSearchRepository  {
    func searchRepos(query: String, page: Int, pageSize: Int, response: @escaping ((Result<RepositoryResult, Error>) -> Void)) -> Cancellable? {
        return performRequest(request: GithubSearchRouter.searchRepositories(query: query, page: page, pageSize: pageSize)) {[weak self] result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                if let repositoriesResponse = self?.parser.parseResponse(data: data.0, response: RepositoriesResponseNetworkModel.self) {
                   
                    let repositories = repositoriesResponse.repositories?.compactMap{ RepositoryModel(name: $0.name!, fullName: $0.fullName!, url: $0.htmlURL!) }
                    
                    response(.success(RepositoryResult(totalCount: repositoriesResponse.totalCount!,
                                                       items: repositories ?? [])))
                } else {
                    response(.failure(NetworkError.parsingFailed))
                }
            }
        }
    }
    
}
