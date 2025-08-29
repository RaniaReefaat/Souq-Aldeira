//
//  DismissView.swift
//  App
//
//  Created by Ahmed Taha on 14/12/2023.
//

import UIKit

final class DismissView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    
    weak var backFrom: UIViewController?
    
    var title: String = "" {
        didSet {
            headerTitleLabel.text = title.localized
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("DismissView", owner: self)
        contentView.backgroundColor = .whiteColor
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentView.topCornerRadius = 24
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @IBAction private func didTapDismiss(_ sender: Any) {
        backFrom?.dismiss()
    }
}
