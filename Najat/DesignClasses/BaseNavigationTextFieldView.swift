//
//  BaseNavigationTextFieldView.swift
//  Dukan
//
//  Created by Ahmed Taha on 16/05/2023.
//

import UIKit

class BaseNavigationTextFieldView: UIView {
    
    var backVCFrom: UIViewController?
    var notificationsVCFrom: UIViewController?
    
    var title: String? {
        didSet {
            titleLabel.text = title?.localized
        }
    }
    
    private lazy var searchWithAlertContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("007460")
        return view
    }()
    
    private lazy var searchContentView: ViewWithButtonEffect = {
        let view = ViewWithButtonEffect()
        view.backgroundColor = .hex("FFFFFF")
        self.setupSearchContentView(view)
        return view
    }()
    
    private lazy var searchImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "NewSearch")
        return image
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .semiBoldFont(of: 15)
        textField.textColor = .hex("A8A8A8")
        textField.placeholder = "Food & beverage".localized
        return textField
    }()
    
    private lazy var alertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(named: "NewNotification"), for: .normal)
        button.tintColor = .hex("FFFFFF")
        return button
    }()
    
    private lazy var newLogo: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "NavigationIcon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentMode = .scaleToFill
        button.isEnabled = false
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
        view.backgroundColor = .hex("DCF3F3")
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
        setupNewLogo()
        setupSearchView()
        setupBackView()
        setupActions()
    }
    
    private func setupStackView() {
        let vStack = UIStackView(arrangedSubviews: [searchWithAlertContentView, backWithTitleContentView])
        vStack.distribution = .fill
        vStack.axis = .vertical
        addSubview(vStack)
        searchWithAlertContentView.heightAnchorConstant(constant: 110)
        vStack.heightAnchorConstant(constant: 145)
        vStack.topAnchorSuperView(constant: 0)
        vStack.leadingAnchorSuperView(constant: 0)
        vStack.trailingAnchorSuperView(constant: 0)
    }
    
    private func setupAlertView() {
        searchWithAlertContentView.addSubview(alertButton)
        alertButton.heightAnchorConstant(constant: 24)
        alertButton.widthAnchorConstant(constant: 24)
        alertButton.trailingAnchorSuperView(constant: 16)
        alertButton.bottomAnchorSuperView(constant: 18)
    }
    
    private func setupNewLogo() {
        searchWithAlertContentView.addSubview(newLogo)
        newLogo.heightAnchorConstant(constant: 40)
        newLogo.widthAnchorConstant(constant: 80)
        newLogo.leadingAnchorSuperView(constant: 16)
        newLogo.bottomAnchorSuperView(constant: 10)
    }
    
    private func setupSearchView() {
        let hStack = UIStackView(arrangedSubviews: [searchImage, searchTextField])
        hStack.distribution = .fill
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        let h2Stack = UIStackView(arrangedSubviews: [hStack])
        h2Stack.distribution = .fill
        h2Stack.axis = .horizontal
        h2Stack.spacing = 10
        
        searchWithAlertContentView.addSubview(searchContentView)
        searchContentView.trailingAnchorToView(anchor: alertButton.trailingAnchor, constant: -32)
        searchContentView.heightAnchorConstant(constant: 50)
        searchContentView.bottomAnchorSuperView(constant: 10)
        searchContentView.leadingAnchorToView(anchor: newLogo.trailingAnchor, constant: 10)
        searchContentView.centerYToView(anchor: alertButton.centerYAnchor)
        searchContentView.addSubview(h2Stack)
        searchImage.widthAnchorConstant(constant: 20)
        
        h2Stack.heightAnchorConstant(constant: 20)
        h2Stack.leadingAnchorSuperView(constant: 12)
        h2Stack.trailingAnchorSuperView(constant: 12)
        h2Stack.centerYToView(anchor: searchContentView.centerYAnchor)
    }
    
    private func setupSearchContentView(_ view: UIView) {
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        if LanguageManger.getCurrentLanguage() == LangEnum.Arabic.rawValue {
//            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        } else {
//            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
//        }
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
        alertButton.addTarget(self, action: #selector(alertButtonPressed), for: .touchUpInside)
    }
    
    @objc private func alertButtonPressed() {
        //MARK: TODO
    }
    
    @objc private func backButtonTapped() {
        backVCFrom?.dismiss(animated: true)
        backVCFrom?.popMe()
    }
}
