//
//  EmptyView.swift
//  Loopz
//
//  Created by Ahmed Taha on 18/06/2024.
//

import UIKit

final class EmptyView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var emptyStateImage: UIImageView!
    @IBOutlet private weak var emptyStateTitleLabel: UILabel!
    @IBOutlet private weak var emptyStateBodyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(with type: EmptyViewTypes) {
        emptyStateImage.image = type.image
        emptyStateTitleLabel.text = type.title.localized
        emptyStateBodyLabel.text = type.body.localized
    }
}

// MARK: - Setup Navigation with own view
private extension EmptyView {
    private func setupView() {
        Bundle.main.loadNibNamed("EmptyView", owner: self)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
