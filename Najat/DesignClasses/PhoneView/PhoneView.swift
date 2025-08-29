//
//  PhoneView.swift
//  Dukan
//
//  Created by mohammed balegh on 06/03/2023.
//

import UIKit

final class PhoneView: UIView {
    
    @IBOutlet private weak var phoneHeaderView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var phoneStackView: UIView!
    @IBOutlet private weak var countryPickerView: ViewWithButtonEffect!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    
    var validPhoneNumber: ((Bool) -> Void)?
    var onCountryClick: (() -> Void)?
    var limit = 8
    
    @Published var hasErrorValidation = false
    var phoneNumber: String {
        get {
            return phoneNumberTextField.text ?? ""
        } set {
            phoneNumberTextField.text = newValue
        }
    }
    
    var countryCode: String? = nil {
        didSet { countryPickerView.label?.text = countryCode }
    }
    
    var flagImage: String = "" {
        didSet { countryPickerView.imageView?.load(with: flagImage) }
    }
    
    var isValidPhoneNumber: Bool {
        do {
            try Validator.validatePhone(with: phoneNumberTextField.text, count: limit)
            showSuccess()
            return true
        }
        catch {
            UIView.animate(withDuration: 0.53, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.errorLabel.isHidden = false
            } completion: { [weak self] _ in
                self?.showFailure(error: error.validatorErrorAssociatedMessage)
            }
            return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PhoneView", owner: self)
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setup()
    }

    func setup() {
        countryPickerView.target = { [weak self] in
            guard let self else { return }
            onCountryClick?()
        }
        phoneHeaderView.isHidden = phoneNumber.isEmpty
        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.tintColor = .blue
        phoneNumberTextField.addTarget(self, action: #selector(self.checkIfValidWithin), for: .editingChanged)
    }
    
    func showFailure(error: String) {
        errorLabel.isHidden = false
        hasErrorValidation = true
        separatorView.backgroundColor = UIColor.hex("#EF233C")
        phoneStackView.layer.borderColor = UIColor.hex("#EF233C").cgColor
        errorLabel.text = error
    }
    
    func showSuccess() {
        separatorView.backgroundColor = UIColor.hex("479F50")
        phoneStackView.layer.borderColor = UIColor.hex("479F50").cgColor
    }

    func dismissError() {
        errorLabel.isHidden = true
        hasErrorValidation = false
        phoneStackView.layer.borderColor = UIColor.gray.cgColor
        separatorView.backgroundColor = .clear
    }

    func didSelectCountry(_ item: CountriesModel) {
        limit = item.phoneNumberLimit ?? 0
        phoneNumberTextField.text = ""
        countryCode = item.showPhoneCode ?? ""
        flagImage = item.image ?? ""
    }
    
    @objc
    private func checkIfValidWithin() {
        validPhoneNumber?(phoneNumberTextField.text?.count == limit && isValidPhoneNumber)
    }
}

extension PhoneView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.checkForCharacterLimit(with: limit, count: textField.text?.count ?? 0, stringCount: string.count, range: range)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        dismissError()
        phoneHeaderView.isHidden = (phoneNumberTextField.text?.isEmpty ?? true)
    }
}
