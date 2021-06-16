//
//  Flow.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
public protocol Flow {
    var nextFlow: Flow? { get }
    func start()
}
