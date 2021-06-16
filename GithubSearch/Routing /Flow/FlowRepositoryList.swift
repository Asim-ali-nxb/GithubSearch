//
//  FlowRepositoryList.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
final class FlowRepositoryList: Flow {
    var nextFlow: Flow?
    private let delegate: RepositoryListDelegate

    init(delegate: RepositoryListDelegate) {
        self.delegate = delegate
        self.nextFlow = nil
    }
    
    func start() {
        delegate.loadListViewController(selectionCallBack: {[unowned self] url, title in
            self.delegate.loadWebViewController(withURL: url, title: title)
        })
    }
}
