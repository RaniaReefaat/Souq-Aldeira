//
//  ProductDetailsViewController.swift
//  Najat
//
//  Created by rania refaat on 03/07/2024.
//

import UIKit

class ProductDetailsViewController: BaseController , UIScrollViewDelegate{
    
    @IBOutlet weak var addToCartButton: AppFontButton!
    @IBOutlet weak var contactsStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editItemButton: AppFontButton!
    @IBOutlet weak var bestSellerView: UIView!
    @IBOutlet weak var likesLabel: UILabel!

    private var playIndex = 0
    private var delegate: UpdateProductDetailsFavoriteAction?
    private var isChanged: Bool = false
    
    var isFavorite = Bool() {
        didSet {
            if isFavorite{
                likeButton.setImage(UIImage(named: "love"), for: .normal)
            }else{
                likeButton.setImage(UIImage(named: "love1"), for: .normal)
            }
        }
    }
    
    private lazy var viewModel: ProductDetailsViewModel = {
        ProductDetailsViewModel(coordinator: coordinator)
    }()
    
    private var productID: Int
    private var mediaArray = [Media]()
    private var visibleIndexPaths: [IndexPath] = []
    private var whatsAppNumber = String()
    private var email = String()
    
    init(productID: Int , delegate: UpdateProductDetailsFavoriteAction?) {
        self.productID = productID
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let newIndexPath = IndexPath(item: playIndex, section: 0)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? ProductSliderCollectionViewCell {
            cell.pauseVideo()
        }
        if isChanged {
            delegate?.updateProductDetailsFavoriteAction(productId: productID, isChanged: isChanged)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(AppStrings.productDetails.message)
        setupCollectionView()
        bind()
    }

    private func setupCollectionView() {
        [collectionView].forEach({$0?.delegate = self})
        [collectionView].forEach({$0?.dataSource = self})
        collectionView.register(cellType: ProductSliderCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        [collectionView].forEach({$0?.showsVerticalScrollIndicator = false})
        [collectionView].forEach({$0?.showsHorizontalScrollIndicator = false})
        
    }
    
    @IBAction func addToCartButtonTapped(_ sender: AppFontButton) {
        Task {
            await viewModel.addToCart(productID: productID)
        }
        
    }
    @IBAction func whatsappButtonTapped(_ sender: UIButton) {
        openWhatsApp(withPhoneNumber: whatsAppNumber, messageText: nil)
    }
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "mailto:\(email)") {
            openURL(url: url)
        }
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareButtonTapped(shareLink: viewModel.productData?.shareLink ?? "", productName: viewModel.productData?.name ?? "", description: viewModel.productData?.description ?? "")
        
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
      
        if isFavorite {
            Task {
                await viewModel.addToFavorite(productID: productID, fileID: 0)
            }
            isFavorite.toggle()
        }else{
            let vc = AddToFavoriteListViewController(delegate: self, index: 0)
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
    @IBAction func didTapEdit(_ sender: Any) {
        let item = viewModel.productData
        push(AddItemViewController(itemDetails: item))
    }
    
    @IBAction func storeButtonTapped(_ sender: UIButton) {
        push(StoreDetailsViewController(storeID: viewModel.productData?.store?.id ?? 0))
    }
    private func shareButtonTapped(shareLink: String, productName: String, description: String) {
        var fixedText = "Product Name:".localized
        fixedText += " \(productName) \n"
        fixedText += "Link:".localized
        fixedText += " \(shareLink)"
//        fixedText += "\(description)"
        let textToShare = [ fixedText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ProductSliderCollectionViewCell.self, for: indexPath)
        
        let media = mediaArray[indexPath.row]
        let isImage = media.isImage ?? false
        cell.configCell(media: media)
        cell.videoImageView.isHidden = true
        if isImage {
            cell.muteButton.isHidden = true
        }else{
            cell.muteButton.isHidden = false
        }
        cell.muteTapped = { [weak self] in
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
                cell.toggleMute()
                if cell.isMuted {
                    cell.muteButton.setImage(UIImage(named: "mute"), for: .normal)
                }else{
                    cell.muteButton.setImage( UIImage(named: "unmute") , for: .normal)
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
            //            cell.isMute.toggle()
            print("didSelectItemAt")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width)  , height: collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        pageControl.currentPage = indexPath.row
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll ended")
        handleScrollEnd()
    }
    private func handleScrollEnd() {
        
        print(playIndex)
        let indexPath = IndexPath(item: playIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
            cell.pauseVideo()
        }
        guard let collectionView = self.collectionView else { return }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Get the center of the collection view
        let centerPoint = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        
        // Find the closest visible cell to the center
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            print("Center index path: \(centerIndexPath)")
            playIndex = centerIndexPath.row
        }
        
        print(playIndex)
        
        if !(mediaArray[playIndex].isImage ?? false) {
            let newIndexPath = IndexPath(item: playIndex, section: 0)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? ProductSliderCollectionViewCell {
                cell.playVideo(media: mediaArray[newIndexPath.row])
            }
        }
        pageControl.currentPage = playIndex
        
    }
    private func playFirstCellVideo() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
            cell.playVideo(media: mediaArray[indexPath.row])
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
                    cell.playVideo(media: self.mediaArray[indexPath.row])
                }
            }
        }
    }
}

// MARK: Binding
extension ProductDetailsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindProductsData()
        getProductsData()
        bindCartCount()
    }
    func getProductsData() {
        Task {
            await viewModel.getProductDetails(productID:productID)
        }
    }
    private func bindCartCount() {
        viewModel.$cartCount.sink { [weak self] count in
            guard let self else { return }
            if let count = count{
                setCartCount(cartCount: count)
            }
        }.store(in: &cancellable)
    }
    private func setCartCount(cartCount: Int){
        if let tabItems = tabBarController?.tabBar.items {
            let userType = UserDefaults.userData?.role ?? .user
            if userType == .store {
                let cartTab = tabItems[3] // Change index to your actual Cart tab index
                cartTab.badgeValue = cartCount > 0 ? "\(cartCount)" : nil

            }else{
                let cartTab = tabItems[2] // Change index to your actual Cart tab index
                cartTab.badgeValue = cartCount > 0 ? "\(cartCount)" : nil

            }
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindProductsData() {
        viewModel.$reloadProducts.sink { [weak self] status in
            guard let self, status else { return }
            setProductData(data: viewModel.productData)
        }.store(in: &cancellable)
    }
    private func setProductData(data: Products?){
        guard let data = data else{return}
        let isFavourite = data.isFavourite ?? false
        isFavorite = isFavourite
        
        
        // store
        storeNameLabel.text = data.store?.name
        storeImageView.load(with: data.store?.image)
        
        // product
        productNameLabel.text = data.name
        productDetailsLabel.text = data.description
        timeLabel.text = data.createdAt
        //        editItemButton.isHidden = data.
        let price = data.price
        
        let isMyProduct = data.store?.id ?? 0 == UserDefaults.userData?.id ?? 0
        if isMyProduct {
            addToCartButton.isHidden = true
            editItemButton.isHidden = false
            contactsStackView.isHidden = true
        }else{
            editItemButton.isHidden = true
            if price != nil {
                addToCartButton.isHidden = false
                contactsStackView.isHidden = true
            }else{
                addToCartButton.isHidden = true
                contactsStackView.isHidden = false
            }
        }
        if price != nil {
            priceView.isHidden = false
            priceLabel.text = price!.addCurrency
        }else{
            priceView.isHidden = true
        }

        self.mediaArray = data.media ?? []
        collectionView.reloadData()
        pageControl.numberOfPages = mediaArray.count
        if !(mediaArray.first?.isImage ?? false) {
            playFirstCellVideo()
        }
        whatsAppNumber = data.store?.whatsapp ?? ""
        email = data.store?.email ?? ""
        likesNumberLabel.text = data.likes?.string
        if data.likes == 1 {
            likesLabel.text = AppStrings.like.message
        }else{
            likesLabel.text = AppStrings.Likes.message
        }
        let isBestSeller = data.isBestSeller ?? true
        if isBestSeller{
            bestSellerView.isHidden = false
        }else{
            bestSellerView.isHidden = true
        }
        let lang = L102Language.getCurrentLanguage()
        if lang == "ar" {
            bestSellerView.clipsToBounds = true
            bestSellerView.layer.cornerRadius = 10
            bestSellerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] // Top right corner, Top left corner respectively

        }else{
//            bestSellerView.rightCornerRadius = 0
//            bestSellerView.leftCornerRadius = 10
            bestSellerView.clipsToBounds = true
            bestSellerView.layer.cornerRadius = 10
            bestSellerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Top right corner, Top left corner respectively

        }
    }
}
extension ProductDetailsViewController: SelectFavoriteFileID{
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        Task {
            await viewModel.addToFavorite(productID: productID, fileID: id)
        }
        isChanged = true
        isFavorite.toggle()
    }
    
}
protocol UpdateProductDetailsFavoriteAction{
    func updateProductDetailsFavoriteAction(productId: Int, isChanged: Bool)
}
