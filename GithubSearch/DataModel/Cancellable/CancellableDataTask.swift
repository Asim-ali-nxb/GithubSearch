//
//  Cancellable.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

final public class CancellableDataTask: Cancellable {
    var task: URLSessionDataTask
    
    public init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public func cancelRequest() {
        self.task.cancel()
    }
}
