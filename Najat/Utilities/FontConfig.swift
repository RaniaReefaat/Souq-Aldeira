//
//  FontConfig.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class AppFontLabel: UILabel {
        
    @IBInspectable var fontSize: CGFloat = 0.0
    private var fontName = String()
    
    @IBInspectable var isLight: Bool = false {
        didSet {
            if isLight {
                fontName = "KalligArb-Light"
                setFont()
            }
        }
    }
    @IBInspectable var isRegular: Bool = false {
        didSet {
            if isRegular {
                fontName = "KalligArb-Regular"
                setFont()
            }
        }
    }
    
    @IBInspectable var isMedium: Bool = false {
        didSet {
            if isMedium {
                fontName = "KalligArb-Medium"
                setFont()
            }
        }
    }
    
    @IBInspectable var isSemiBold: Bool = false {
        didSet {
            if isSemiBold {
                fontName = "KalligArb-Semibold"
                setFont()
            }
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            if isBold {
                fontName = "KalligArb-Bold"
                setFont()
            }
        }
    }
    func setFont(){
        self.font = UIFont.init(name: fontName, size: fontSize)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setFont()
    }
}
class AppFontTextField: UITextField {
        
    @IBInspectable var fontSize: CGFloat = 0.0
    private var fontName = String()
    
    @IBInspectable var isLight: Bool = false {
        didSet {
            if isLight {
                fontName = "KalligArb-Light"
                setFont()
            }
        }
    }
    @IBInspectable var isRegular: Bool = false {
        didSet {
            if isRegular {
                fontName = "KalligArb-Regular"
                setFont()
            }
        }
    }
    
    @IBInspectable var isMedium: Bool = false {
        didSet {
            if isMedium {
                fontName = "KalligArb-Medium"
                setFont()
            }
        }
    }
    
    @IBInspectable var isSemiBold: Bool = false {
        didSet {
            if isSemiBold {
                fontName = "KalligArb-Semibold"
                setFont()
            }
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            if isBold {
                fontName = "KalligArb-Bold"
                setFont()
            }
        }
    }
    func setFont(){
        self.font = UIFont.init(name: fontName, size: fontSize)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setFont()
    }
}
class AppFontButton: UIButton {
        
    @IBInspectable var fontSize: CGFloat = 0.0
    private var fontName = String()
    
    @IBInspectable var isLight: Bool = false {
        didSet {
            if isLight {
                fontName = "KalligArb-Light"
                setFont()
            }
        }
    }
    @IBInspectable var isRegular: Bool = false {
        didSet {
            if isRegular {
                fontName = "KalligArb-Regular"
                setFont()
            }
        }
    }
    
    @IBInspectable var isMedium: Bool = false {
        didSet {
            if isMedium {
                fontName = "KalligArb-Medium"
                setFont()
            }
        }
    }
    
    @IBInspectable var isSemiBold: Bool = false {
        didSet {
            if isSemiBold {
                fontName = "KalligArb-Semibold"
                setFont()
            }
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            if isBold {
                fontName = "KalligArb-Bold"
                setFont()
            }
        }
    }
    func setFont(){
        self.titleLabel?.font = UIFont.init(name: fontName, size: fontSize)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setFont()
    }
}
class AppFontTextView: UITextView {
        
    @IBInspectable var fontSize: CGFloat = 0.0
    private var fontName = String()
    
    @IBInspectable var isLight: Bool = false {
        didSet {
            if isLight {
                fontName = "KalligArb-Light"
                setFont()
            }
        }
    }
    @IBInspectable var isRegular: Bool = false {
        didSet {
            if isRegular {
                fontName = "KalligArb-Regular"
                setFont()
            }
        }
    }
    
    @IBInspectable var isMedium: Bool = false {
        didSet {
            if isMedium {
                fontName = "KalligArb-Medium"
                setFont()
            }
        }
    }
    
    @IBInspectable var isSemiBold: Bool = false {
        didSet {
            if isSemiBold {
                fontName = "KalligArb-Semibold"
                setFont()
            }
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            if isBold {
                fontName = "KalligArb-Bold"
                setFont()
            }
        }
    }
    func setFont(){
        self.font = UIFont.init(name: fontName, size: fontSize)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setFont()
    }
}
