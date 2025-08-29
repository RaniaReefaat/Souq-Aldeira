//
//  CustomNavigationView.swift
//  Dukan
//
//  Created by Ahmed Taha on 26/03/2023.
//

import UIKit

//MARK: NavigationView Height = 145
class CustomNavigationView: UIView {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backWithTitleView: UIView!
    @IBOutlet weak var searchContentView: UIView!
    @IBOutlet weak var navigationHeaderLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var searchView: ViewWithButtonEffect!
    
    //For Search products
    @IBOutlet weak var searchWithTextFieldView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var changeButtonAction: (() -> ())?
    var shareButtonAction: (() -> ())?
    var addListButtonAction: (() -> ())?
    var backTarget: (() -> ())?
    var removeItemTarget: (() -> ())?
    
    weak var backVCFrom: UIViewController?
    weak var searchVCFrom: UIViewController?
    weak var notificationsVCFrom: UIViewController?
    
    var title: String? {
        didSet {
            navigationHeaderLabel.text = title?.localized
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        searchViewTapped()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        searchViewTapped()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSearchContentView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("CustomNavigationView", owner: self)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupContent(vc: UIViewController, title: String, hideBack: Bool) {
        self.title = title
        backVCFrom = vc
        backButton.isHidden = hideBack
    }
    
    private func setupSearchContentView() {
        [searchContentView, searchWithTextFieldView]
            .forEach {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 20
            }
//        if LanguageManger.getCurrentLanguage() == LangEnum.Arabic.rawValue {
//            [searchContentView, searchWithTextFieldView].forEach {
//                $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//            }
//        } else {
//            [searchContentView, searchWithTextFieldView].forEach {
//                $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
//            }
//        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        backTarget?()
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        changeButtonAction?()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareButtonAction?()
    }
    
    @IBAction func addListButtonTapped(_ sender: Any) {
        addListButtonAction?()
    }
    
    private func searchViewTapped() {
        searchView.target = {
            //MARK: TODO
        }
    }
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        removeItemTarget?()
    }
    
    @IBAction func notificationsButtonTapped(_ sender: Any) {
        //MARK: TODO
    }
}

extension UIView {
    func setupCornerRound(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
    
    @IBInspectable
    var leftCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Top right corner, Top left corner respectively
        }
    }
    @IBInspectable
    var rightCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] // Top right corner, Top left corner respectively
//
//            self.roundCorners([.bottomRight, .topRight], radius: newValue)
//            self.layer.masksToBounds = true
        }
    }
    @IBInspectable
    var topLeftCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.roundCorners([.topLeft], radius: newValue)
        }
    }
    
    @IBInspectable
    var topRightCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.roundCorners([.topRight], radius: newValue)
        }
    }

    @IBInspectable
    var bottomRightCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.roundCorners([.bottomRight], radius: newValue)
        }
    }
    
    @IBInspectable
    var right: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }

    @IBInspectable
    var left: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var rotateView: CGFloat {
        get {
            let radians = atan2(transform.b, transform.a)
            let degrees = radians * (180 / CGFloat.pi)
            return degrees
        }
        set {
            transform = transform.rotated(by: newValue)
        }
    }
}
