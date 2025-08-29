//
//  ViewWithButtonEffect.swift
//  New-Zoz-Resturant
//
//  Created by Youssef on 12/01/2023.
//

import UIKit

class ViewWithLabel: UIView {
    
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var imageView: UIImageView?
}

class ViewWithButtonEffect: UIView {
    
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    
    public var isEnabled: Bool = true
    public var isEffectEnabled: Bool = true
    public var target: (() -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouch(_:))))
        isUserInteractionEnabled = true
    }
    
    @objc
    private func didTouch(_ sender: UITapGestureRecognizer) {
        guard isEnabled else { return }
        target?()
        beginAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_DURATION) {
            self.endAnimation()
        }
    }
    
    private let ANIMATION_DURATION: TimeInterval = 0.1
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        beginAnimation()
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        endAnimation()
    }
    
    private func beginAnimation() {
        guard isEnabled else { return }
        guard isEffectEnabled else { return }
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.alpha = 0.7
            self.subviews.forEach({ $0.alpha = 0.2 })
        }
    }
    
    private func endAnimation() {
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.alpha = 1
            self.subviews.forEach({ $0.alpha = 1 })
        }
    }
}

class ImageWithButtonEffect: UIImageView {
        
    public var isEnabled: Bool = true
    public var isEffectEnabled: Bool = true
    public var target: (() -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouch(_:))))
        isUserInteractionEnabled = true
    }
    
    @objc
    private func didTouch(_ sender: UITapGestureRecognizer) {
        guard isEnabled else { return }
        target?()
        beginAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_DURATION) {
            self.endAnimation()
        }
    }
    
    private let ANIMATION_DURATION: TimeInterval = 0.1
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        beginAnimation()
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        endAnimation()
    }
    
    private func beginAnimation() {
        guard isEnabled else { return }
        guard isEffectEnabled else { return }
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.alpha = 0.7
            self.subviews.forEach({ $0.alpha = 0.2 })
        }
    }
    
    private func endAnimation() {
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.alpha = 1
            self.subviews.forEach({ $0.alpha = 1 })
        }
    }
}

class ProfileDataView: ViewWithButtonEffect {
    @IBOutlet weak var addedSuccessStack: UIView?
    
    private var isAdded: Bool = false {
        didSet {
            if isAdded {
                addedSuccessStack?.isHidden = false
            } else {
                addedSuccessStack?.isHidden = true
            }
        }
    }
}

