//
//  RepositoryWebViewController.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import UIKit
import Combine
import WebKit

class RepositoryWebViewController: UIViewController {
    
    // MARK: - Vars
    private var viewModel: RepositoryWebViewModel
    private var subscriptions = [AnyCancellable]()
    
    // MARK: - UIView Components
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(webView)
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    // MARK: - Init
    init(viewModel: RepositoryWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private init() {
        fatalError("Can't be initialised without required parameters")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.addSubview(stackView)
        view.addSubview(loadingIndicator)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Binding ViewModel
private extension RepositoryWebViewController {
    private func bindViewModel() {

        viewModel.repoURL
            .sink {[weak self] request in
                DispatchQueue.main.async {
                    self?.webView.load(request)
                }
            }.store(in: &subscriptions)
        
        viewModel.repoTitle
            .sink {[weak self] title in
                DispatchQueue.main.async {
                    self?.title = title
                }
            }.store(in: &subscriptions)
    }
}

extension RepositoryWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingActivity(loading: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingActivity(loading: false)
    }
}

// MARK: - View Protocol
extension RepositoryWebViewController {
    override func loadingActivity(loading: Bool) {
        DispatchQueue.main.async {[unowned self] in
            loading ? self.loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    override func showError(title: String, message: String) {
        DispatchQueue.main.async {[unowned self] in
            self.loadingIndicator.stopAnimating()
        }
        super.showError(title: title, message: message)
    }
}

