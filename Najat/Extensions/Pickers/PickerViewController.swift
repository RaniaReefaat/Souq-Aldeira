//
//  PickerViewController.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

protocol SendPickerViewSelection: class {
    func pickerResult(item: String)
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowsData[o: row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = rowsData[o: row] {
            delegate?.pickerResult(item: item)
            selectedItem?(item)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    private weak var delegate: SendPickerViewSelection?
    var rowsData: [String]
    
    var selectedItem: ((_ item: String)->())?
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    init(itemsToShow: [String], delegate: SendPickerViewSelection? = nil) {
        self.delegate = delegate
        rowsData = itemsToShow
        super.init(nibName: nil, bundle: nil)
        
        if itemsToShow.isEmpty {
            dismiss(animated: false, completion: nil)
            return
        }
        
        pickerView.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let dismisslaView = UIView()
        view.addSubview(dismisslaView)
        dismisslaView.fillSuperviewSafeArea()
        dismisslaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMe)))
        
        let pickerViewBackView = UIView()
        pickerViewBackView.backgroundColor = .gray
        view.addSubview(pickerViewBackView)
        pickerViewBackView.widthAnchorWithMultiplier(multiplier: 1)
        pickerViewBackView.heightAnchorConstant(constant: 150)
        pickerViewBackView.centerXInSuperview()
        pickerViewBackView.bottomAnchorSuperView(constant: 0)
        
        pickerViewBackView.addSubview(pickerView)
        pickerView.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = rowsData[o: 0] {
            delegate?.pickerResult(item: item)
            selectedItem?(item)
        }
    }
    
   
}

extension Collection {
    subscript(o index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class DataPicker:  UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static var shared = DataPicker()
    var array = [String]() {
        didSet{
            if array.count > 0 {
                isEmptyData = false
            }else{
                array =  ["No Data Found".localized]
                isEmptyData = true
            }
        }
    }
    private var txtFiled : UITextField!
    static let instance = DataPicker()
    private var selectedIndex:Int?
    private var view : UIView!
    private var isEmptyData = true
    
    private var completion: ((Int?) -> Void)?
    private var picker = UIPickerView()
    
    func initPickerView(arrayString:[String] = [],txtField : UITextField , view : UIView, complition:((Int?) -> Void)?) {
        
        self.txtFiled = txtField
        self.view = view
        self.array = arrayString
        self.delegate = self
        txtField.inputView = self
        createToolbar()

        if arrayString.isEmpty {
            isEmptyData = true
        }else{
            isEmptyData = false
        }
       
        
        complition?(nil)
        self.completion = complition
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(doneKeyboard))
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([doneButton,flexibleSpace, cancelButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        txtFiled.inputAccessoryView = toolBar
    }
    @objc func doneKeyboard(){
        if isEmptyData {
            completion?(nil)
        }else{
            if  txtFiled.text == nil || txtFiled.text == "" {
                txtFiled.text = array.first
                completion?(0)
            }else{
                print(selectedIndex)
                if selectedIndex == nil {
                    selectedIndex = 0
                }
                completion?(selectedIndex)
            }
        }
        view.endEditing(true)
    }
    @objc func dismissKeyboard(){
            completion?(nil)
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard array.count > 0  else {
            view.endEditing(true)
            return nil}
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard array.count > 0 else{return}
        if !isEmptyData {
            txtFiled.text = array[row]
            completion?(row)
            selectedIndex = row
        }
    }
}
