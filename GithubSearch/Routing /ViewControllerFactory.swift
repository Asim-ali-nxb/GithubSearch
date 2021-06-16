//
//  ViewControllerFactory.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import UIKit

public typealias ItemSelection = (URL, String)->()
protocol ViewControllerFactory {
    func repositoryListViewController(selectionCallback:@escaping ItemSelection) -> UIViewController
    func repositoryWebViewController(url: URL, title: String) -> UIViewController
}
