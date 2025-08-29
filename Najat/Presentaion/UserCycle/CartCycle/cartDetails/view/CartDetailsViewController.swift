//
//  CartDetailsViewController.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class CartDetailsViewController: BaseController {
   // views
    @IBOutlet private weak var storeView: UIView!
    @IBOutlet private weak var itemsStackView: UIStackView!
    @IBOutlet private weak var noteStackView: UIStackView!
    @IBOutlet private weak var summeryStackView: UIStackView!
    @IBOutlet private weak var trackingButton: UIButton!
    
    //outlets
    @IBOutlet private weak var marketLogoImageView: UIImageView!
    @IBOutlet private weak var marketNameLabel: AppFontLabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var notesTextView: PlaceHolderTextView!
    @IBOutlet private weak var totalProductLabel: AppFontLabel!
    @IBOutlet private weak var deliveryLabel: AppFontLabel!
    @IBOutlet private weak var totalPriceLabel: AppFontLabel!

    private lazy var viewModel: CartDetailsViewModellProtocol = {
        CartDetailsViewModel(coordinator: coordinator)
    }()
  
    var cartID: Int?
    private var storeID = Int()
    
    init(cartID: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.cartID = cartID
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
        getCartListRequest(cartID: cartID.unwrapped(or: -1))
    }
    
    @IBAction func didTapAddMore(_ sender: Any) {
        push(StoreDetailsViewController(storeID: storeID))
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        push(ConfirmOrderViewController(cartItem: viewModel.cartItem, notes: notesTextView.text))
    }
}

private extension CartDetailsViewController {
    
    func setupView() {
        addNotifyButton()
        setupTableView()
        setTitle(AppStrings.cart.message)
        notesTextView.placeholder = NSString(utf8String: AppStrings.feedback.message)
        var lang = L102Language.getCurrentLanguage()
        if lang == "ar" {
            notesTextView.semanticContentAttribute = .forceRightToLeft
            notesTextView.textAlignment = .right
        }else if lang == "en"{
            notesTextView.semanticContentAttribute = .forceLeftToRight
            notesTextView.textAlignment = .left
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CartDetailsProductsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    func fillData(at model: CartDataModel) {
        marketLogoImageView.load(with: model.store.image)
        marketNameLabel.text = model.store.name
        totalProductLabel.text = model.subtotal.string
        deliveryLabel.text = model.deliveryFee.string
        totalPriceLabel.text = model.total.string
        setupEmptyViews(status: model.items.isEmpty)
        storeID = model.store.id ?? 0
    }
    
    func setupEmptyViews(status: Bool = false) {
        storeView.isHidden = status
        itemsStackView.isHidden = status
        noteStackView.isHidden = status
        summeryStackView.isHidden = status
        trackingButton.isHidden = status
    }
}

extension CartDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        CartDetailsCell(at: indexPath)
    }

    func CartDetailsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CartDetailsProductsTableViewCell.self, for: indexPath)
        let cellData = viewModel.cellData(at: indexPath.row)
        cell.configCell(for: cellData)
       
        let isFavorite = cellData.product?.isFavourite ?? false
        
        cell.likeItem = {[weak self] in
            guard let self else { return }
            
            if isFavorite {
                let id = cellData.product?.id ?? 0
                favouritToggleRequest(productID: id, indexPath: indexPath)
                viewModel.toggleFavourit(productID: id)
                tableView.reloadRows(at: [indexPath], with: .automatic)

            }else{
                let vc = AddToFavoriteListViewController(delegate: self, index: indexPath.row)
                if #available(iOS 15.0, *) {
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.prefersGrabberVisible = true
                        sheet.largestUndimmedDetentIdentifier = .medium
                        sheet.preferredCornerRadius = 20
                        sheet.prefersEdgeAttachedInCompactHeight = true
                    }
                } else {
                    // Fallback on earlier versions
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
        cell.addItems = {[weak self] in
            guard let self else { return }
            let id = cellData.id.unwrapped(or: -1)
            if cell.getQnt() == 0 {
                removeItemRequest(cartID: cartID.unwrapped(or: -1), productID: id)
            }else{
                let body = AddToCartBody(
                    productId: cellData.product?.id?.string ?? "",
                    qty: cell.getQnt().string
                )
                addItemRequest(body: body)
            }
        }
        
        cell.removeItems = {[weak self] in
            guard let self else { return }
            let id = cellData.id.unwrapped(or: -1)
            removeItemRequest(cartID: cartID.unwrapped(or: -1), productID: id)
        }
        
        return cell
    }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        //           let isRead = itemCellList[indexPath.row].isRead
        let title =  AppStrings.remove.message
        let readAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self] (_, _, completionHandler) in
                guard let self = self else{return}
                Task {
                    let cellData = self.viewModel.cellData(at: indexPath.row)
                    let id = cellData.id.unwrapped(or: -1)
                    self.removeItemRequest(cartID: self.cartID.unwrapped(or: -1), productID: id)

                }
                completionHandler(true)
            }
        )
        let readLabel = UILabel()
        readLabel.text = title
        readLabel.font = .regularFont(of: 12)
        readLabel.sizeToFit()
        readLabel.textColor = .white
        
        readAction.image = addLabelToImage(image: UIImage(named: "remove")!, label: readLabel)
        
        readAction.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.003921568627, blue: 0.2078431373, alpha: 1)
        
        let actions: [UIContextualAction] = [readAction]
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Custom logic goes in here
        true
    }
}

private extension CartDetailsViewController {
    
    func bindUI() {
        bindLoading()
        bindFetchData()
        bindReloadViews()
        bindShowEmptyView()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            $0 ? self?.startLoading() : self?.stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindFetchData() {
        viewModel.uiModel.$fetchData.sink { [weak self] data in
            guard let self, let data else { return }
            fillData(at: data)
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    func bindReloadViews() {
        viewModel.uiModel.$reloadProducts.sink { [weak self] state in
            guard let self, state else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }

    func bindShowEmptyView() {
        viewModel.uiModel.$showEmptyView.sink { [weak self] in
            guard let self else { return }
            
            $0 ? self.showEmptyView(with: .cart) : self.removeEmptyView()
            setupEmptyViews(status: $0)
        }.store(in: &cancellable)
    }
}
private extension CartDetailsViewController {
    
    func getCartListRequest(cartID: Int) {
        Task {
            await viewModel.getCartDetailsRequest(cartID: cartID)
        }
    }
    
    func favouritToggleRequest(productID: Int, indexPath: IndexPath) {
        Task {
            await viewModel.addToFavorite(productID: productID, fileID: 0)
        }
    }
    func addItemRequest(body: AddToCartBody) {
        Task {
            await viewModel.addtemCart(body: body)
        }
    }
    
    func removeItemRequest(cartID: Int, productID: Int) {
        Task {
            await viewModel.deleteItemCart(cartID: cartID, itemID: productID)
        }
    }
}
extension CartDetailsViewController: SelectFavoriteFileID{
   
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cellData = viewModel.cellData(at: indexPath.row)
        Task {
            await viewModel.addToFavorite(productID: cellData.product?.id ?? 0, fileID: id)
        }
        viewModel.toggleFavourit(productID: cellData.product?.id ?? 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
}
