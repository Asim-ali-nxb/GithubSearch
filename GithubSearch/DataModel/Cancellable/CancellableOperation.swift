//
//  CancellableOperation.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

final public class CancellableOperation: Cancellable {
    private let operation: Operation
    
    public init(operation: Operation) {
        self.operation = operation
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    public func cancelRequest() {
        operation.cancel()
    }
}
