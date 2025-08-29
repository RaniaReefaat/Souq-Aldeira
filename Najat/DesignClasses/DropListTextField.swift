////
////  DropListTextField.swift
////  new-wasselna-driver
////
////  Created by mahroUS on 27/11/2565 BE.
////
//
import UIKit
//
//class DropListTextField: UITextField {
//    
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        
//        let DropListTextFieldImage = UIButton(type: .system)
//        DropListTextFieldImage.setImage(#imageLiteral(resourceName: "dropDown.pdf"), for: .normal)
//        DropListTextFieldImage.tintColor = .mainGray
//        let view = UIView()
//        view.addSubview(DropListTextFieldImage)
//        DropListTextFieldImage.fillSuperview(padding: .init(0, side: 10))
//        
//        rightViewMode = .always
//        rightView = view
//    }
//    
//}
//
//extension DropListTextField: UITextFieldDelegate {
//   
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//      
//        return false
//    }
//    
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        return CGRect.zero
//    }
//    
//    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
//        return []
//    }
//}
//
class DashedLineView: UIView {
    
    var color = UIColor.hex("#65CECB")
    
    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)

        UIColor.white.setFill()
        path.fill()

        color.setStroke()
        path.lineWidth = 2

        let dashPattern : [CGFloat] = [1, 2]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
