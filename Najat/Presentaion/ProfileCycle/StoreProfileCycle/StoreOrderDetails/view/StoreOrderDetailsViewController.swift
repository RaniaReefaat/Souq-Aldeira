//
//  StoreOrderDetailsViewController.swift
//  Najat
//
//  Created by rania refaat on 04/09/2024.
//

import UIKit

class StoreOrderDetailsViewController: BaseController {
    
    @IBOutlet weak var orderNumberLabel: AppFontLabel!
    @IBOutlet weak var addressLabel: AppFontLabel!
    @IBOutlet weak var paymentWayLabel: AppFontLabel!
    @IBOutlet weak var totalPriceLabel: AppFontLabel!
    @IBOutlet weak var statusLabel: AppFontLabel!
    @IBOutlet weak var productsNumberLabel: AppFontLabel!
    @IBOutlet weak var userNameLabel: AppFontLabel!
    @IBOutlet weak var phoneLabel: AppFontLabel!
    @IBOutlet weak var acceptButton: AppFontButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var orderID: Int
    private var productsArray = [ProductItem]()
    private var phoneNumber = String()
    private var address: Address?
    
    init(orderID: Int) {
        self.orderID = orderID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var viewModel: StoreOrderDetailsViewModel = {
        StoreOrderDetailsViewModel(coordinator: coordinator)
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
    @IBAction func phoneButtonTapped(_ sender: AppFontButton) {
        makePhoneCall(phoneNumber: phoneNumber)
    }
    @IBAction func addressButtonTapped(_ sender: AppFontButton) {
        guard let address = address else{return}
        openLocationInGoogleMapsApp(latitude: address.lat ?? "", longitude: address.lng ?? "", placeName: address.address ?? "")
    }
    
    @IBAction func acceptButtonTapped(_ sender: AppFontButton) {
        Task {
            await self.viewModel.acceptOrder(id: orderID)
        }
    }
    
}
extension StoreOrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
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
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: OrderDetailsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
}
// MARK: Binding
extension StoreOrderDetailsViewController {
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
        addressLabel.text = data.address?.name
        paymentWayLabel.text = data.paymentMethod
        totalPriceLabel.text = data.total?.addCurrency
        statusLabel.text = data.statusTranslated
        productsNumberLabel.text = data.productsCount?.string
        userNameLabel.text = data.user?.name
        phoneNumber = data.user?.phone ?? ""
        address = data.address
        
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
        
        let status = data.status ?? .new
        switch status {
        case .new:
            acceptButton.isHidden = false
        default:
            acceptButton.isHidden = true
        }
        phoneLabel.text = phoneNumber
    }
}
