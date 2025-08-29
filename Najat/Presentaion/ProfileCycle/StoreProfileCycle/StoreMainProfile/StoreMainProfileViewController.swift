//
//  StoreMainProfileViewController.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import UIKit

class StoreMainProfileViewController: BaseController {

    @IBOutlet weak var bioLabel: AppFontLabel!
    @IBOutlet weak var nameLabel2: AppFontLabel!
    @IBOutlet weak var followingNumberLabel: AppFontLabel!
    @IBOutlet weak var followersNumberLabel: AppFontLabel!
    @IBOutlet weak var productsNumberLabel: AppFontLabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel1: AppFontLabel!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var requestNumberLabel: AppFontLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var requestsContainerView: UIView!
    @IBOutlet weak var storeRequestsSelectedView: UIView!
    @IBOutlet weak var myProductsSelectedView: UIView!
    @IBOutlet weak var storeRequestsImageView: UIImageView!
    @IBOutlet weak var storeRequestsLabel: AppFontLabel!
    @IBOutlet weak var myProductLabel: AppFontLabel!
    @IBOutlet weak var myProductImageView: UIImageView!
    @IBOutlet weak var newRequestsNumberLabel: AppFontLabel!
    @IBOutlet weak var newRequestsNumberView: UIView!
    
    
    private lazy var viewModel: StoreMainProfileViewModel = {
        StoreMainProfileViewModel(coordinator: coordinator)
    }()
    
    private var profileSelectedType: ProfileSelectedType = .products
    private var productsArray: [StoreProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setSelectedViews()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(status: true)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar(status: false)

    }
    @IBAction func editProfileButtonTapped(_ sender: AppFontButton) {
        push(UpdateStoreProfileViewController())
    }
    @IBAction func menueButtonTapped(_ sender: UIButton) {
        let vc = MainProfileViewController()
        vc.selectTapped = { type in
            switch type {
            case .settings:
                self.push(SettingsViewController())
            case .address:
                self.push(AddressListViewController())
            case .orders:
                self.push(UserOrdersListViewController())
            case .questions:
                self.push(QuestionsViewController())
            case .condition:
                self.push(TermsViewController())
            case .privacy:
                self.push(PrivacyViewController())
            case .contactUS:
                self.push(ContactUSViewController())
            case .aboutApp:
                print("")
            case .logout, .deleteAccount:
                Task {
                    await self.viewModel.logout()
                }
            case .createStore:
                print("")
            }
        }
        customPresent(vc)
    }
    
    @IBAction func ordersButtonTapped(_ sender: UIButton) {
        if profileSelectedType != .orders {
            profileSelectedType = .orders
            setSelectedViews()
            Task {
                await viewModel.getOrders()
            }
        }
    }
    @IBAction func myProductsButtonTapped(_ sender: UIButton) {
        if profileSelectedType != .products {
            profileSelectedType = .products
            setSelectedViews()
        }
    }
    @IBAction func shareButtonTapped(_ sender: AppFontButton) {
        shareButtonTapped(shareLink: UserDefaults.userData?.shareLink ?? "")
    }
    private func shareButtonTapped(shareLink: String) {
//        var fixedText = "Hello! 👋 \n \n I saw your product on the Souq Aldira App".localized
       var fixedText = "\(shareLink) "
//        fixedText += ". I would like to know more details about it. \n \n Can you help me? Thank you!".localized
        let textToShare = [ fixedText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func switchAccountButtonTapped(_ sender: UIButton) {
        let vc = MyAccountsViewController()
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
    @IBAction func followersButtonTapped(_ sender: AppFontButton) {
        push(FollowersListViewController())
    }
    @IBAction func followingButtonTapped(_ sender: AppFontButton) {
        push(FollowedStoresListViewController())
    }
}
extension StoreMainProfileViewController{
    func setSelectedViews(){
        [requestsContainerView, collectionView ].forEach({$0?.isHidden = true})
        [storeRequestsSelectedView , myProductsSelectedView].forEach({$0?.backgroundColor = .clear})
        [storeRequestsImageView , myProductImageView].forEach({$0?.image = UIImage(named: "myProductsUnSelected")})
        [storeRequestsLabel , myProductLabel].forEach({$0?.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)})
        newRequestsNumberView.isHidden = true
        switch profileSelectedType{
        case .orders:
            requestsContainerView.isHidden = false
            storeRequestsSelectedView.backgroundColor = .mainBlack
            storeRequestsImageView.image = UIImage(named: "myProductsSelected")
            storeRequestsLabel.textColor = .mainBlack
        case .products:
            collectionView.isHidden = false
            myProductsSelectedView.backgroundColor = .mainBlack
            myProductImageView.image = UIImage(named: "myProductsSelected")
            myProductLabel.textColor = .mainBlack
        }
    }
}
extension StoreMainProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ProductsImagesCollectionViewCell.self, for: indexPath)
        cell.productImageView.load(with: productsArray[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(ProductDetailsViewController(productID: productsArray[indexPath.row].id ?? 0, delegate: nil))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = collectionView.frame.width / 3 - 10
        //        return CGSize(width: width , height: width)
        let numberOfItemsPerRow: CGFloat = 3
        let itemSpacing: CGFloat = 7 // Space between items
        let totalSpacing: CGFloat = (numberOfItemsPerRow - 1) * itemSpacing
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        let height: CGFloat = 100 // Set height for the cells
        
        return CGSize(width: width, height: width)
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ProductsImagesCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
}
extension StoreMainProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: StoreRequestsTableViewCell.self, for: indexPath)
        cell.configCell(order: viewModel.cellData(at: indexPath.row))
        cell.acceptOrderTapped = { [weak self] in
            guard let self = self else {return}
            Task {
                await self.viewModel.acceptOrder(index:indexPath.row)
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(StoreOrderDetailsViewController(orderID: viewModel.cellData(at: indexPath.row).id ?? 0))
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: StoreRequestsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
    }
}
extension StoreMainProfileViewController {
    private func setUserData(){
        guard let userData = UserDefaults.userData else{return}
        userNameLabel1.text = userData.name
        nameLabel2.text = userData.name
        userImageView.load(with: userData.image)
        bioLabel.text = userData.bio
        productsNumberLabel.text = "\(userData.productsCount ?? 0)"
        followersNumberLabel.text = "\(userData.followers ?? 0)"
        followingNumberLabel.text = "\(userData.followings ?? 0)"
        productsArray = userData.products ?? []
        collectionView.reloadData()
        if productsArray.isEmpty {
            showEmptyView(with: .userProducts)
        }else{
            removeEmptyView()
        }
        let ordersNumber = userData.orders ?? 0
        newRequestsNumberLabel.text = ordersNumber.string
        
        if ordersNumber == 0 {
            newRequestsNumberView.isHidden = true
        }else{
            newRequestsNumberView.isHidden = false
        }

    }
}
// MARK: Binding

extension StoreMainProfileViewController {
    private func bind() {
        Task {
            await viewModel.getProfileData()
        }
        bindLoadingIndicator()
        bindUserDataData()
        bindOrdersData()
        bindAcceptOrderData()
        bindUserLogoutData()
    }
    private func bindUserLogoutData() {
        viewModel.$setUserLogoutDataState.sink { [weak self] status in
            guard let self , status else { return }
            AppDelegate.shared.setRoot()
        }.store(in: &cancellable)
    }
    private func bindOrdersData() {
        viewModel.$reloadData.sink { [weak self] state in
            guard let self else { return }
            requestNumberLabel.text = viewModel.numberOfRows.string
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindAcceptOrderData() {
        viewModel.$acceptOrderMessage.sink { [weak self] message in
            guard let self , (message != nil) else { return }
            showAlert(with: message ?? "", title: .success)
        }.store(in: &cancellable)
    }
    private func bindUserDataData() {
        viewModel.setUserDataState.sink { [weak self] in
            guard let self else { return }
            setUserData()
        }.store(in: &cancellable)
    }
}
