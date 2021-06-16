//
//  GithubSearchRouter.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

enum GithubSearchRouter {
    case searchRepositories(query: String, page: Int, pageSize: Int)
}

extension GithubSearchRouter: Router {
    var method: String {
        "GET"
    }
    var path: String {
        switch self {
        case .searchRepositories:
            return "/repositories"
        }
    }
    private var parameters: [URLQueryItem]? {
        switch self {
        case .searchRepositories(let query, let page, let pageSize):
            return [URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "per_page", value: String(pageSize))]
        }
    }
}

extension GithubSearchRouter: URLRequestConvertable {
    func toURLRequest(baseURL: URL) -> URLRequest? {
        var url = baseURL.appendingPathComponent(path)
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters
            url = components.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
