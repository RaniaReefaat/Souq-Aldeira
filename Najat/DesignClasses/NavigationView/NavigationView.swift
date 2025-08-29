//
//  NavigationView.swift
//  App
//
//  Created by Ahmed Taha on 24/10/2023.
//

import UIKit

final class NavigationView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var deleteAccountButton: UIButton!
    @IBOutlet private weak var clearAllButton: UIButton!
    @IBOutlet private weak var navigationTitleLabel: UILabel!
    @IBOutlet private weak var shareActionView: ViewWithButtonEffect!
    @IBOutlet private weak var likeActionView: ViewWithButtonEffect!
    
    weak var backFrom: UIViewController?
    var didSelectDeleteAccount: (() -> Void)?
    var didSelectLike: (() -> Void)?
    var didSelectShare: (() -> Void)?
    var didSelectClearAll: (() -> Void)?
    
    var title: String = "" {
        didSet {
            navigationTitleLabel.text = title.localized
        }
    }
    
    var showDeleteAccount: Bool = false {
        didSet {
            deleteAccountButton.isHidden = !showDeleteAccount
        }
    }
    
    var showLike: Bool = false {
        didSet {
            likeActionView.isHidden = !showLike
        }
    }
    
    var likeImage: UIImage = .back {
        didSet {
            likeActionView.imageView?.image = likeImage
        }
    }
    
    var showShare: Bool = false {
        didSet {
            shareActionView.isHidden = !showShare
        }
    }
    
    var hideBack: Bool = false {
        didSet {
            backButton.isHidden = hideBack
        }
    }
    
    var clearAll: Bool = false {
        didSet {
            clearAllButton.isHidden = !clearAll
        }
    }
    
    var viewBackgroundColor: UIColor = .label {
        didSet {
            contentView.backgroundColor = viewBackgroundColor
        }
    }
    
    var titleColor: UIColor = .label {
        didSet {
            navigationTitleLabel.textColor = titleColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActionViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActionViews()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("NavigationView", owner: self)
        contentView.backgroundColor = .whiteColor
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        hideViews()
    }
    
    private func hideViews() {
        deleteAccountButton.isHidden = true
        shareActionView.isHidden = true
        likeActionView.isHidden = true
        clearAllButton.isHidden = true
    }
    
    private func setupActionViews() {
        didTapShare()
        didTapLike()
    }
    
    private func didTapShare() {
        shareActionView.target = { [weak self] in
            self?.didSelectShare?()
        }
    }
    
    private func didTapLike() {
        likeActionView.target = { [weak self] in
            self?.didSelectLike?()
        }
    }
    
    @IBAction private func didTapBack(_ sender: Any) {
        backFrom?.dismissMePlease()
        backFrom?.popMe()
    }
    
    @IBAction private func didTapDeleteAccount(_ sender: Any) {
        didSelectDeleteAccount?()
    }
    
    @IBAction private func didTapClearAll(_ sender: Any) {
        didSelectClearAll?()
    }
}
