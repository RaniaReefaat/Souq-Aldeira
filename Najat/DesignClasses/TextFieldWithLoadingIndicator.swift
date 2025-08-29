//
//  TextFieldWithLoadingIndicator.swift
//  Bro-Rider
//
//  Created by mohammed balegh on 30/01/2023.
//

import UIKit

enum ConfirmationType {
    case verify
    case confirm
}

class TextFieldWithLoadingIndicator: AppTextField {

    let confirmButton: ButtonWithLoadingIndication = {
        let button = ButtonWithLoadingIndication(type: .system)
        button.setTitleColor(UIColor.hex("321D74"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat", size: 15) //
        return button
    }()

    let confirmView: UIView = {
        let view = UIView()
        return view
    }()

    public var target: (() -> ())?

    var confirmationType: ConfirmationType = .confirm {
        didSet {
            setTitle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setupButton() {
        confirmButton.addTarget(self, action: #selector(didTouch), for: .touchUpInside)
        confirmView.addSubview(confirmButton)

        confirmButton.fillSuperview(padding: .init(10))

        rightView = confirmView
        rightViewMode = .always

        setTitle()
        layoutIfNeeded()
    }

    func startAnimating() {
        confirmButton.isLoading = true
        confirmButton.setTitle("", for: .normal)
    }

    func stopWithSuccess() {
        confirmButton.isLoading = false
        rightView = nil
    }

    func stopWithFailure() {
        confirmButton.titleLabel?.isHidden = false
        confirmButton.isLoading = false
        setTitle()
    }

    private func setTitle() {
        switch confirmationType {
        case .verify:
            confirmButton.setTitle("Verify", for: .normal)
        case .confirm:
            confirmButton.setTitle("Confirm", for: .normal)
        }
    }

    @objc private func didTouch() {
        guard isEnabled else { return }
        target?()
    }
}
