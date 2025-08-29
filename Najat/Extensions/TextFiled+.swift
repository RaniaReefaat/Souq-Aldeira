//
//  TextFiled+.swift
//  Dinamo
//
//  Created by Youssef on 3/12/21.
//

import UIKit
import Foundation

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage?){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        mainView.layer.cornerRadius = 5
        
        //        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        //        view.backgroundColor = .white
        //        view.clipsToBounds = true
        //        view.layer.cornerRadius = 5
        //        view.layer.borderWidth = CGFloat(0.5)
        //        view.layer.borderColor = colorBorder.cgColor
        //        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 8, width: 13, height: 13)
        mainView.addSubview(imageView)
        
        //        let hLine = UIView()
        //        hLine.backgroundColor = #colorLiteral(red: 0.8117647767, green: 0.8117647767, blue: 0.8117647767, alpha: 1)
        //        hLine.frame = CGRect(x: 0, y: 0, width: 1, height: 30)
        //        mainView.addSubview(hLine)
        
//        if AppMainLang.isRTLLanguage() {
//            let hLine = UIView()
//            hLine.backgroundColor = #colorLiteral(red: 0.8117647767, green: 0.8117647767, blue: 0.8117647767, alpha: 1)
//            hLine.frame = CGRect(x: 0, y: 0, width: 1, height: 30)
//            mainView.addSubview(hLine)
//        } else {
            let hLine = UIView()
            hLine.backgroundColor = #colorLiteral(red: 0.8117647767, green: 0.8117647767, blue: 0.8117647767, alpha: 1)
            hLine.frame = CGRect(x: 30, y: 0, width: 1, height: 30)
            mainView.addSubview(hLine)
//        }
        
        mainView.frame = .init(origin: mainView.frame.origin, size: .init(width: 35, height: mainView.frame.height))
        
        //        let seperatorView = UIView()
        //        seperatorView.backgroundColor = colorSeparator
        //        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            //            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            //            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        //        self.layer.borderColor = colorBorder.cgColor
        //        self.layer.borderWidth = CGFloat(0.5)
        //        self.layer.cornerRadius = 5
    }
    
}
extension UITextView {
    
    func resolveHashTags() {
        
        let nsText:NSString = self.text! as NSString
        
        let words:[NSString] = nsText.components(separatedBy: " ") as [NSString]
        
        let attributes = [
            NSAttributedString.Key.font : UIFont.boldFont(of: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attributes)
        
        for word in words {
            let dict = ["Edit": "Edit", "#": "hash://"]
            for (key, value) in dict
            {
                if word.hasPrefix(key)
                {
                    let matchRange:NSRange = nsText.range(of: word as String)
                    
                    var stringifiedWord: String = word as String
                    
                    stringifiedWord = String(stringifiedWord.dropFirst(key.count))
                    let escapedWord  = stringifiedWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let stringURL = "\(value)\(escapedWord ?? "")"
                    if let url = URL.init(string:stringURL) {
                        attrString.addAttribute(.link, value: stringURL, range: matchRange)
                        print(url)
                    }
                    else
                    {
                        print("Oooops with \(stringifiedWord) invalid URL: \(stringURL)")
                    }
                }
            }
        }
        
        self.attributedText = attrString
    }
}
class DigitField: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        NotificationCenter.default.post(name: Notification.Name("goPrevious"), object: nil)
    }
}
class TextFieldSpinner: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.cut(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.copy(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.select(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.decreaseSize(_:)) {
        return false
    }
    
    if action == #selector(UIResponderStandardEditActions.increaseSize(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.toggleBoldface(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.perform(_:)) {
        return false
    }
    if action == #selector(UIResponderStandardEditActions.perform(_:)) {
        return false
    }
        return super.canPerformAction(action, withSender: sender)
   }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
   
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    

}
