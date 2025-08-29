//
//  ButtonWithLoadingIndication.swift
//  Bro-Rider
//
//  Created by mohammed balegh on 30/01/2023.
//

import Foundation

import UIKit

class ButtonWithLoadingIndication: UIButton {

    var spinner = UIActivityIndicatorView()

    var isLoading = false {
        didSet {
            updateView()
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

    func setupView() {
        spinner.hidesWhenStopped = true
        spinner.color = .darkGray
        spinner.style = .medium

        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0
            imageView?.alpha = 0
            isEnabled = false
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            imageView?.alpha = 0
            isEnabled = true
        }
    }
}
class FlipButtonImage: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()
      let lang = L102Language.getCurrentLanguage()

      if lang == langugae.arabic.lang{
      self.transform = CGAffineTransform(scaleX: -1, y: 1)
    }else{
      self.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
  }
}
