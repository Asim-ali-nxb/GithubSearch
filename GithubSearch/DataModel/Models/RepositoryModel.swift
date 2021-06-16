//
//  RepositoryModel.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

public struct RepositoryModel {
    public let id: Int
    public let name: String
    public let fullName: String
    public let url: String
    
    public init(id: Int, name: String, fullName: String, url: String) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.url = url
    }
}
