//
//  RepositoryCell.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit

/// Cell to show ui of repository
final class RepositoryCell: UICollectionViewCell {
    
    private let ownerIconImageSize: CGSize = .init(width: 25, height: 25)
    
    private lazy var ownerIconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.layer.cornerRadius = ownerIconImageSize.height / 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var ownerNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .caption1)
        view.textColor = .secondaryLabel
        return view
    }()
    
    private lazy var repoNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .headline)
        view.textColor = .label
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 6
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = .label
        return view
    }()
    
    private lazy var starIconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "star")
        view.tintColor = .systemGray
        return view
    }()
    
    private lazy var starCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = .secondaryLabel
        return view
    }()
    
    private lazy var languageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = .secondaryLabel
        return view
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

extension RepositoryCell {
    
    private func setUp() {
        let mainContainer = UIStackView()
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.axis = .vertical
        mainContainer.spacing = 6
        mainContainer.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        mainContainer.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(mainContainer)
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        let mainContainerBottomConstraint = mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        mainContainerBottomConstraint.isActive = true
        mainContainerBottomConstraint.priority = .defaultHigh
        
        let ownerContainer = UIStackView()
        ownerContainer.translatesAutoresizingMaskIntoConstraints = false
        ownerContainer.axis = .horizontal
        ownerContainer.spacing = 10
        
        NSLayoutConstraint.activate([
            ownerIconImageView.widthAnchor.constraint(equalToConstant: ownerIconImageSize.width),
            ownerIconImageView.heightAnchor.constraint(equalToConstant: ownerIconImageSize.height)
        ])
        
        ownerContainer.addArrangedSubview(ownerIconImageView)
        ownerContainer.addArrangedSubview(ownerNameLabel)
        
        mainContainer.addArrangedSubview(ownerContainer)
        mainContainer.addArrangedSubview(repoNameLabel)
        mainContainer.addArrangedSubview(descriptionLabel)
        
        let starsAndLanguageContainer = UIStackView()
        starsAndLanguageContainer.translatesAutoresizingMaskIntoConstraints = false
        starsAndLanguageContainer.axis = .horizontal
        starsAndLanguageContainer.spacing = 20
        
        let starsContainer = UIStackView()
        starsContainer.translatesAutoresizingMaskIntoConstraints = false
        starsContainer.axis = .horizontal
        starsContainer.spacing = 4
        
        NSLayoutConstraint.activate([
            starIconImageView.widthAnchor.constraint(equalToConstant: 20),
            starIconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        starsContainer.addArrangedSubview(starIconImageView)
        starsContainer.addArrangedSubview(starCountLabel)
        
        starsAndLanguageContainer.addArrangedSubview(starsContainer)
        starsAndLanguageContainer.addArrangedSubview(languageLabel)
        starsAndLanguageContainer.addArrangedSubview(UIView.stackViewSpacer(.horizontal))
        
        mainContainer.addArrangedSubview(starsAndLanguageContainer)
        
        contentView.addSubview(bottomLineView)
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension RepositoryCell: ConfigurableCell {
    
    func configure(_ data: RepositoryDisplayItem) {
        ownerIconImageView.setImageUrl(data.ownerIconImageUrlString)
        ownerNameLabel.text = data.ownerName
        repoNameLabel.text = data.repositoryName
        descriptionLabel.text = data.repositoryDescription
        starCountLabel.text = data.stars
        languageLabel.text = data.language
    }
}
