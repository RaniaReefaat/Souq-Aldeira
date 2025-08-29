//
//  CustomPickerViewController.swift
//  Core
//
//  Created by Youssef on 01/03/2021.
//  Copyright © 2021 Orcas. All rights reserved.
//

import UIKit

protocol CustomPickerItemProtocol: AnyObject {
    var id: String { get }
    var value: String { get }
    var isSelected: Bool { get set }
    var leadingImageUrl : String? { get }
}

class CustomPickerViewController: PopupViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableViewbackView: UIView!
    @IBOutlet weak var tableviewHeightConstrans: NSLayoutConstraint!
    @IBOutlet weak var tableview: SelfSizedUITableView!
    
    private var selectionCompletion: ((_ item: CustomPickerItemProtocol)->())
    private var dataSource: [CustomPickerItemProtocol]
    private let headerValue: String?
    private let singleSelect: Bool
    
    init(headerValue: String? = nil, dataSource: [CustomPickerItemProtocol], singleSelect: Bool = true, selectionCompletion: @escaping ((_ item: CustomPickerItemProtocol) -> ())) {
        self.dataSource = dataSource
        self.headerValue = headerValue
        self.singleSelect = singleSelect
        self.selectionCompletion = selectionCompletion
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = headerValue
        tableViewbackView.cornerRadiusTop(value: 30)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewButton)))
        setupTableview()
    }
    
    private func setupTableview() {
        tableview.register(cellType: CustomPickerTableViewCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.heightDelegate = self
        tableview.dataSource = self
        tableview.separatorColor = .clear
    }
    
    @objc func dismissViewButton() {
        self.dismiss(animated: true, completion: nil)
       
    }
}

extension CustomPickerViewController: UIScrollViewHeighDelegate {
    func UIScrollView(_ uiScrollView: UIScrollView, didUIScrollViewHeightChanged height: CGFloat) {
        tableviewHeightConstrans.constant = height
    }
}

extension CustomPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPickerTableViewCell") as! CustomPickerTableViewCell
        cell.config(item: dataSource[indexPath.row])
        cell.selectionView.target = {[weak self] in
            self?.tableView(didSelectRowAt: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension CustomPickerViewController {
    func tableView(didSelectRowAt indexPath: IndexPath) {
        if singleSelect {
            dataSource.forEach({ $0.isSelected = false })
        }
        
        dataSource[indexPath.row].isSelected = true
        selectionCompletion(dataSource[indexPath.row])
        
        dismissView()
    }
}

