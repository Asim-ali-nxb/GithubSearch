//
//  View.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation

protocol ErrorView {
    func showError(title: String, message: String)
}

protocol LoadingIndicatorView {
    func loadingActivity(loading: Bool)
}

protocol View: AnyObject, ErrorView, LoadingIndicatorView { }
