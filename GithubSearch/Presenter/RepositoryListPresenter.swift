//
//  RepositoryListPresenter.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
struct RepositoryListPresenter: Hashable {
    let id = UUID()
    let name: String
    let fullName: String
    let repositoryURL: String
}
