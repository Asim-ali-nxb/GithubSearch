//
//  URLRequestConvertible.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
protocol URLRequestConvertable {
    func toURLRequest(baseURL: URL) -> URLRequest?
}
