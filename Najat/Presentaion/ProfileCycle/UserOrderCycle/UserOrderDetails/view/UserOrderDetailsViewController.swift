//
//  UserOrderDetailsViewController.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import UIKit

class UserOrderDetailsViewController: BaseController {
    
    @IBOutlet weak var orderNumberLabel: AppFontLabel!
    @IBOutlet weak var addressLabel: AppFontLabel!
    @IBOutlet weak var paymentWayLabel: AppFontLabel!
    @IBOutlet weak var totalPriceLabel: AppFontLabel!
    @IBOutlet weak var statusLabel: AppFontLabel!
    @IBOutlet weak var productsNumberLabel: AppFontLabel!
    @IBOutlet weak var storeNameLabel: AppFontLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var orderID: Int
    private var productsArray = [ProductItem]()

    init(orderID: Int) {
        self.orderID = orderID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var viewModel: UserOrderDetailsViewModel = {
        UserOrderDetailsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setTitle(AppStrings.orderDetails.message)
        bind()

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        
        tableHeight.constant = tableView.contentSize.height
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.updateViewConstraints()
            self?.loadViewIfNeeded()
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: OrderDetailsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
}
extension UserOrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderDetailsTableViewCell.self, for: indexPath)
        cell.configCell(product: productsArray[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
// MARK: Binding
extension UserOrderDetailsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindOrderDetailsData()
        getOrderDetailsData()
    }
    func getOrderDetailsData() {
        Task {
            await viewModel.getOrderDetails(orderID:orderID)
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }

    private func bindOrderDetailsData() {
        viewModel.$reloadData.sink { [weak self] status in
            guard let self, status else { return }
            setOrderDetailsData(data: viewModel.orderData)
        }.store(in: &cancellable)
    }
    private func setOrderDetailsData(data: OrderDetailsModelData?){
        guard let data = data else{return}
       
        //products
        productsArray = data.items ?? []
        tableView.reloadData()
        
        //order data
        orderNumberLabel.text = data.id?.string
        var nameAddress = String()
        var address = data.address
        nameAddress = address?.area?.name ?? ""
        nameAddress += " - "
        nameAddress += "Street".localized
        nameAddress += " \(address?.streetNo ?? "") - "
        nameAddress += "Home".localized
        nameAddress += " \(address?.homeNo ?? "") - "
        nameAddress += "Apartment".localized
        nameAddress += " \(address?.flatNo ?? "")"
        addressLabel.text = nameAddress

        paymentWayLabel.text = data.paymentMethod
        totalPriceLabel.text = data.total?.addCurrency
        statusLabel.text = data.statusTranslated
        productsNumberLabel.text = data.productsCount?.string
        storeNameLabel.text = data.store?.name
    }
}
