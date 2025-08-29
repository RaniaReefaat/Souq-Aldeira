import Foundation
import UIKit

enum RightButtonState {
    case address
    case arrowDown
    case calender
}

final class AppTextFieldWithRightButton: AppTextField {
    
    var rightButtonAction: (() -> Void)?
    
    private var rightButtonState: RightButtonState = .address {
        didSet {
            updateRightButtonImage()
        }
    }
    
    private func updateRightButtonImage() {
        let imageName: String
        switch rightButtonState {
        case .address:
            imageName = "blackLocationIcon"
        case .arrowDown:
            imageName = "black-drop-down"
        case .calender:
            imageName = "calendar"
        }
        
        let buttonImage = UIImage(named: imageName)
        let rightButton = createRightButton(with: buttonImage)
        rightView = createRightView(with: rightButton)
    }
    
    private func createRightButton(with image: UIImage?) -> UIButton {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = .lightGray
        rightButton.addTarget(self, action: #selector(didTapRightButton(_:)), for: .touchUpInside)
        return rightButton
    }
    
    private func createRightView(with button: UIButton) -> UIView {
        let view = UIView()
        view.addSubview(button)
        button.fillSuperview(padding: .init(0, side: 10))
        return view
    }
    
    func setRightButtonState(_ state: RightButtonState) {
        rightButtonState = state
    }
    
    @objc
    private func didTapRightButton(_ sender: UIButton) {
        rightButtonAction?()
    }
}
