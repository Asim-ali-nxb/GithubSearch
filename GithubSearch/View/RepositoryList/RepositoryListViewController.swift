//
//  ViewController.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import UIKit
import Combine

class RepositoryListViewController: UIViewController {
    
    // MARK: - Vars
    private let selection: ItemSelection
    private var viewModel: RepositoryListViewModel
    private var subscriptions = [AnyCancellable]()
    private var dataSource: DataSource!
    
    // MARK: - UIView Components
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(searchBar)
        view.addArrangedSubview(tableView)
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchBarStyle = .minimal
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableFooterView = UIView()
        view.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "cell")
        view.keyboardDismissMode = .onDrag
        view.separatorInset = .zero
        view.delegate = self
        return view
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    // MARK: - Init
    init(viewModel: RepositoryListViewModel, selection:@escaping ItemSelection) {
        self.viewModel = viewModel
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
        searchBar.placeholder = viewModel.searchPlaceholder
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        searchBar.becomeFirstResponder()
    }
}

// MARK: - UITableViewDelegate
extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: viewModel.dataItems.value[indexPath.row].repositoryURL) {
            selection(url, viewModel.dataItems.value[indexPath.row].name)
        }
    }
}

// MARK: - Binding ViewModel
private extension RepositoryListViewController {
    private func bindViewModel() {
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let cell = cell as? RepositoryListTableViewCell {
                cell.setData(data: itemIdentifier)
            }
            return cell
        }
        
        viewModel.dataItems
            .sink {[weak self] items in
                var snapshot = NSDiffableDataSourceSnapshot<String, RepositoryListPresenter>()
                snapshot.appendSections([""])
                snapshot.appendItems(items, toSection: "")
                DispatchQueue.main.async {
                    self?.dataSource.apply(snapshot)
                }
            }.store(in: &subscriptions)
    }
}

// MARK: - View Protocol
extension RepositoryListViewController {
    override func loadingActivity(loading: Bool) {
        DispatchQueue.main.async {[unowned self] in
            loading ? self.loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            self.tableView.isUserInteractionEnabled = !loading
        }
    }
    
    override func showError(title: String, message: String) {
        DispatchQueue.main.async {[unowned self] in
            self.loadingIndicator.stopAnimating()
        }
        super.showError(title: title, message: message)
    }
}


// MARK: - Tableview Datasource
fileprivate class DataSource: UITableViewDiffableDataSource<String, RepositoryListPresenter> {

}

// MARK: - SearchBar Delegate
extension RepositoryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.send(searchText)
    }
}

