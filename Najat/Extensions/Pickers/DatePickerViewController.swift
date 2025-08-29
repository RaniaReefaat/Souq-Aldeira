//
//  DatePickerViewController.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

protocol SendSelectedDateProtocol: AnyObject {
    func selected(date: String)
}

class DatePickerViewController: UIViewController {
    
    private weak var delegate: SendSelectedDateProtocol?
    
    lazy var pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        }
        picker.viewBorderWidth = 0.5
        picker.viewBorderColor = .lightGray
        picker.viewCornerRadius = 8
        picker.datePickerMode = type
        return picker
    }()
    lazy var confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select".localize, for: .normal)
        btn.setTitleColor(.white, for: .normal)
//        btn.titleLabel?.font = .cairoRegular(of: 15)
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .mainColor
        btn.addTarget(action: {[weak self] in
            guard let self = self else { return }
            if self.type == .date {
                self.delegate?.selected(date: self.getDateToStringDate())
            } else if self.type == .dateAndTime {
                self.delegate?.selected(date: self.getDateAndTimeToString())
            } else {
                self.delegate?.selected(date: self.getDateToStringTime())
            }
//            self.dismissMePlease()
        })
        return btn
    }()
    
    private var type: UIDatePicker.Mode
    
    init(type: UIDatePicker.Mode, delegate: SendSelectedDateProtocol) {
        self.delegate = delegate
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            
        } else {
//            let dismissGeasture = UITapGestureRecognizer(target: self, action: #selector(dismissMePlease))
            view.isUserInteractionEnabled = true
//            view.addGestureRecognizer(dismissGeasture)
        }
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.viewBorderWidth = 0.5
        containerView.viewBorderColor = #colorLiteral(red: 0.89402318, green: 0.8941735625, blue: 0.89400208, alpha: 1)
        containerView.viewCornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.19), alpha: 1, x: 0, y: 3, blur: 2, spread: 0)
        
        view.addSubview(containerView)
        containerView.centerYInSuperview()
        containerView.centerXInSuperview()
        containerView.widthAnchorConstant(constant: 350)
        containerView.heightAnchorConstant(constant: 450)
        
        containerView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.widthAnchorWithMultiplier(multiplier: 0.9),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            confirmButton.centerXInSuperview(),
            confirmButton.bottomAnchorSuperView(constant: 10)
            ])
        
        containerView.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.widthAnchorWithMultiplier(multiplier: 0.95),
            pickerView.centerXInSuperview(),
            pickerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            pickerView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -10)
            ])
    }
    
    func getDateToStringDate() -> String {
        let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a" // date + time
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringafd = formatter.string(from: pickerView.date)
        return myStringafd
    }
    
    func getDateToStringTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let myStringafd = formatter.string(from: pickerView.date)
        return myStringafd
    }
    
    func getDateAndTimeToString() -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a" // date + time
        let myStringafd = formatter.string(from: pickerView.date)
        return myStringafd
    }
}

class DateConverter {
    static func convertToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let reuslt = dateFormatter.date(from: string) ?? nil
        return reuslt
    }
    
    static func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "E, d MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getDayName(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
