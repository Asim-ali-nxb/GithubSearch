//
//  RepositoryListTableViewCell.swift
//  GithubSearch
//
//  Created by Asim Ali on 15/06/2021.
//

import Foundation
import UIKit

final class RepositoryListTableViewCell: UITableViewCell {
    
    // MARK: - Vars
    private var cancellable: Cancellable?
    
    // MARK: - UIView Components
    private lazy var verticalStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(labelTitle)
        return view
    }()
    private lazy var labelTitle: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - Internal Methods
    func setData(data: RepositoryListPresenter) { //.DataItem) {
        labelTitle.text = data.fullName
    }
}
