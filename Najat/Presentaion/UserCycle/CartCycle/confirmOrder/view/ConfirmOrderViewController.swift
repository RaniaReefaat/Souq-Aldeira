//
//  ConfirmOrderViewController.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class ConfirmOrderViewController: BaseController {

    @IBOutlet private weak var paymentTableView: UITableView!
    @IBOutlet private weak var tableView: UITableView!
   // location view
    @IBOutlet private weak var locationTitleLabel: AppFontLabel!
    @IBOutlet private weak var locationDescLabel: AppFontLabel!
    @IBOutlet private weak var chooseLocationButton: AppFontButton!
 
    // note view
    @IBOutlet private weak var notesTextView: PlaceHolderTextView!
 
    // coupon view
    @IBOutlet private weak var couponTextfield: AppFontTextField!
    @IBOutlet private weak var activeCouponButton: AppFontButton!
    @IBOutlet private weak var removeCouponButton: AppFontButton!
    
    // summary
    @IBOutlet private weak var subTotalLabel: AppFontLabel!
    @IBOutlet private weak var deliveryLabel: AppFontLabel!
    @IBOutlet private weak var discountLabel: AppFontLabel!
    @IBOutlet private weak var totalPriceLabel: AppFontLabel!
    
    @IBOutlet private weak var payButton: AppFontButton!
    @IBOutlet private weak var locationStackView: UIStackView!
    @IBOutlet private weak var discountStackView: UIStackView!

    private lazy var viewModel: ConfirmOrderViewModellProtocol = {
        ConfirmOrderViewModel(coordinator: coordinator)
    }()
    var addressID: Int?
    var cartItem: CartDataModel?
    var notes: String?
    
    private var couponISApplied = false
    
    init(cartItem: CartDataModel?, notes: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.cartItem = cartItem
        self.notes = notes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindAddressData()
        getAddressRequest()
    }
    @IBAction private func didTapCheckCoupon(_ sender: Any) {
        checkoutCouponRequest(code: couponTextfield.text ?? "", subtotal: cartItem?.subtotal.string ?? "")
    }
    
    @IBAction private func didTapRemoveCoupon(_ sender: Any) {
        couponISApplied = false
        removeCouponButton.isHidden = true
        activeCouponButton.isHidden = false
        let totalPrice = (Double(cartItem?.total ?? 0))
        discountLabel.text = "0"
        discountStackView.isHidden = true
        totalPriceLabel.text = totalPrice.rounded(toPlaces: 1).string.addCurrency
        couponTextfield.text = nil
    }
    
    @IBAction private func chooseAddressButtonTapped(_ sender: AppFontButton) {
        push(AddressListViewController(delegate: self))
    }
   
    @IBAction private func didTapPay(_ sender: Any) {
        if addressID == nil {
            showAlert(with: "Please add delivery address".localized, title: .error)
        }else{
            let body = CheckCartBody(
                paymentMethod: "online",
                addressId: addressID?.string ?? "",
                coupon: couponTextfield.text
            )
            Task {
                await viewModel.getConfirmOrderRequest(cartID: cartItem?.id.string ?? "", body: body)
            }
        }
    }
}

private extension ConfirmOrderViewController {
    
    func setupView() {
        addNotifyButton()
        setupTableView()
        setTitle(AppStrings.cart.message)
        setupSummary()
        let lang = L102Language.getCurrentLanguage()
        if lang == "ar" {
            notesTextView.textAlignment = .right
        }else{
            notesTextView.textAlignment = .left
        }
        
        notesTextView.text = notes
        notesTextView.placeholder = NSString(utf8String: AppStrings.feedback.message)

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ConfirmOrderTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(cellType: PaymentMethodTableViewCell.self)
        paymentTableView.separatorStyle = .none
        paymentTableView.showsVerticalScrollIndicator = false
        paymentTableView.showsHorizontalScrollIndicator = false
    }
    
    func setupAddress(model: AddressEntity) {
        addressID = model.id.unwrapped(or: -1)
        locationTitleLabel.text = model.name
        locationDescLabel.text = model.address
    }

    func setupSummary() {
        subTotalLabel.text = cartItem?.subtotal.string.addCurrency
        deliveryLabel.text = cartItem?.deliveryFee.string.addCurrency
        discountLabel.text = "0".addCurrency
        discountStackView.isHidden = true
        totalPriceLabel.text = cartItem?.total.string.addCurrency
    }
}

extension ConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (tableView == self.tableView) ? cartItem?.items.count ?? 0 : viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        (tableView == self.tableView) ? CartDetailsCell(at: indexPath) : paynentsCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymentTableView {
            viewModel.checkPayment(at: indexPath.row)
        }
    }
    
    func CartDetailsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(with: ConfirmOrderTableViewCell.self, for: indexPath)
        guard let item = cartItem?.items[indexPath.row] else { return UITableViewCell() }
        cell.configCell(with: item)
        return cell
    }
    
    func paynentsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = self.paymentTableView.dequeueReusableCell(with: PaymentMethodTableViewCell.self, for: indexPath)
        let item = viewModel.cellData(at: indexPath.row)
        cell.configCell(with: item)
        return cell
    }

    
}

private extension ConfirmOrderViewController {
    
    func bindUI() {
        bindLoading()
        bindFetchData()
        bindCouponData()
        
//        getPaymentsRequest()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            $0 ? self?.startLoading() : self?.stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindFetchData() {
        viewModel.uiModel.$fetchData.sink { [weak self] data in
            guard let self else { return }
            paymentTableView.reloadData()
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    func bindAddressData() {
        viewModel.uiModel.$fetchAddress.sink { [weak self] data in
            guard let self else{ return }
            if data == nil {
                self.locationStackView.isHidden = true
            }else{
                self.locationStackView.isHidden = false
                setupAddress(model: data!)

            }
        }.store(in: &cancellable)
    }

    func bindCouponData() {
        viewModel.uiModel.$couponValue.sink { [weak self] data in
            guard let self, let data else { return }
            let totalPrice = (Double(cartItem?.total ?? 0)) - (data.double ?? 0.0)
            discountLabel.text = data.addCurrency
            discountStackView.isHidden = false
            totalPriceLabel.text = totalPrice.rounded(toPlaces: 1).string.addCurrency
            couponISApplied = true
            removeCouponButton.isHidden = false
            activeCouponButton.isHidden = true
        }.store(in: &cancellable)
    }
}

private extension ConfirmOrderViewController {
    
    func makeChecoutRequest() {
        Task {
//            await viewModel.getCartDetailsRequest(cartID: cartID)
        }
    }
    
    func checkoutCouponRequest(code: String, subtotal: String) {
        Task {
            await viewModel.addCoupon(code: code, subtotal: subtotal)
        }
    }
    func getPaymentsRequest() {
        Task {
            await viewModel.getPaymentMethods()
        }
    }
    
    func getAddressRequest() {
        Task {
            await viewModel.getAddress()
        }
    }
    
}

extension ConfirmOrderViewController: MyAddressDelegate {
    func updateShippingAddress(_ address: AddressEntity) {
        locationStackView.isHidden = false
        setupAddress(model: address)
    }
}
