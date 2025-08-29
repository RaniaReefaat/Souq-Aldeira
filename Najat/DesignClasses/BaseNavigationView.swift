//
//  BaseNavigationView.swift
//  Dukan
//
//  Created by Ahmed Taha on 05/03/2023.
//

import UIKit

class BaseNavigationView: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title?.localized
        }
    }
    var backVCFrom: UIViewController?

    private lazy var searchWithAlertContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("479F50")
        return view
    }()

    private lazy var searchContentView: ViewWithButtonEffect = {
        let view = ViewWithButtonEffect()
        view.backgroundColor = .hex("FFFFFF")
        return view
    }()

    private lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Search")
        return image
    }()

    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBoldFont(of: 15)
        label.textColor = .hex("A8A8A8")
        label.text = "search products".localized
        return label
    }()

    private lazy var alertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(named: "Notification"), for: .normal)
        button.tintColor = .hex("272727")
        return button
    }()

    private lazy var qrCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(named: "BarCode"), for: .normal)
        button.tintColor = .hex("272727")
        return button
    }()

    private lazy var backWithTitleContentView: UIView = {
       let view = UIView()
        view.backgroundColor = .hex("EEF9CB")
        return view
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(named: "back"), for: .normal)
        button.tintColor = .hex("272727")
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldFont(of: 18)
        label.textColor = .hex("272727")
        label.textAlignment = .center
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupAlertView()
        setupSearchView()
        setupBackView()
        setupActions()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupAlertView()
        setupSearchView()
        setupBackView()
        setupActions()
    }

    private func setupAlertView() {
        searchWithAlertContentView.addSubview(alertButton)
        alertButton.heightAnchorConstant(constant: 24)
        alertButton.widthAnchorConstant(constant: 24)
        alertButton.leadingAnchorSuperView(constant: 15)
        alertButton.bottomAnchorSuperView(constant: 19)
    }

    private func setupStackView() {
        let vStack = UIStackView(arrangedSubviews: [searchWithAlertContentView, backWithTitleContentView])
        vStack.distribution = .fill
        vStack.axis = .vertical
        addSubview(vStack)
        searchWithAlertContentView.heightAnchorConstant(constant: 110)
        vStack.heightAnchorConstant(constant: 150)
        vStack.topAnchorSuperView(constant: 0)
        vStack.leadingAnchorSuperView(constant: 0)
        vStack.trailingAnchorSuperView(constant: 0)
    }

    private func setupSearchView() {
        let hStack = UIStackView(arrangedSubviews: [searchImage, searchLabel])
        hStack.distribution = .fill
        hStack.axis = .horizontal
        hStack.spacing = 10

        searchWithAlertContentView.addSubview(searchContentView)
        searchContentView.leadingAnchorToView(anchor: alertButton.trailingAnchor, constant: 14)
        searchContentView.heightAnchorConstant(constant: 40)
        searchContentView.trailingAnchorSuperView(constant: 16)
        searchContentView.centerYToView(anchor: alertButton.centerYAnchor)
        searchContentView.withCorner(4)

        searchContentView.addSubview(hStack)
        searchImage.widthAnchorConstant(constant: 20)
        hStack.heightAnchorConstant(constant: 20)
        hStack.leadingAnchorSuperView(constant: 14)
        hStack.trailingAnchorSuperView(constant: 14)
        hStack.centerYToView(anchor: searchContentView.centerYAnchor)
    }

    private func setupBackView() {
        backWithTitleContentView.addSubview(backButton)
        backButton.widthAnchorConstant(constant: 25)
        backButton.heightAnchorConstant(constant: 30)
        backButton.leadingAnchorSuperView(constant: 20)
        backButton.centerYToView(anchor: backWithTitleContentView.centerYAnchor)

        backWithTitleContentView.addSubview(titleLabel)
        titleLabel.centerX(to: backWithTitleContentView.centerXAnchor)
        titleLabel.centerYToView(anchor: backWithTitleContentView.centerYAnchor)
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        backVCFrom?.dismiss(animated: true)
    }
}
