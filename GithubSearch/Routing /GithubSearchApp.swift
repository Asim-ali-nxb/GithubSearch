//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

public final class GithubSearchApp {
    private let flow: Flow
    
    private init(flow: Flow) {
        self.flow = flow
    }
    
    public static func start(flow: Flow) -> GithubSearchApp {
        flow.start()
        return GithubSearchApp(flow: flow)
    }
    
}







