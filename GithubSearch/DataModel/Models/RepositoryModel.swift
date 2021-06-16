//
//  RepositoryModel.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

struct RepositoryModel {
    let name: String
    let fullName: String
    let url: String
    
    init(name: String, fullName: String, url: String) {
        self.name = name
        self.fullName = fullName
        self.url = url
    }
}

struct RepositoryResult {
    let totalCount: Int
    let items: [RepositoryModel]
    
    init(totalCount: Int, items: [RepositoryModel]) {
        self.totalCount = totalCount
        self.items = items
    }
}
