//
//  HomeViewController.swift
//  Najat
//
//  Created by rania refaat on 12/06/2024.
//

import UIKit

class HomeViewController: BaseController , UIScrollViewDelegate{

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createStoreButton: UIButton!

    
    var timer: Timer?
    var counter = 0
    var currentPage = 0
    
    private lazy var viewModel: HomeViewModel = {
        HomeViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTitleImage(name: "NRedLogo2")
//        addNotifyButton()
//        addAddStoreButton()
        reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        reloadData()
        hideNavigationBar(status: true)
        setCreateStoreButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseTimer()
        hideNavigationBar(status: false)

    }
//   private func addAddStoreButton(){
//        let notifyImage = UIImage(named: "createStore")
//        let notifyButton = UIButton()
//        notifyButton.setImage(notifyImage, for: .normal)
//        notifyButton.addTarget(self, action: #selector(addStoreButtonTapped), for: .touchUpInside)
//        notifyButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
//        let customBarButton = UIBarButtonItem(customView: notifyButton)
//        
//        navigationItem.leftBarButtonItem = customBarButton
//    }
//    @objc func addStoreButtonTapped() {
//        push(CreateStoreViewController())
//        print("add store tapped")
//    }
    private func reloadData(){
        setupCollectionView()
        setupTableView()
        viewModel.viewWillAppear()
//        pauseTimer()
        bind()
        scrollView.delegate = self
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
        tableView.register(cellType: ProductsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
//        tableView.isPagingEnabled = true
        tableView.isScrollEnabled = false  // Disable tableView scrolling

        
    }
    private func setupCollectionView() {
        [sliderCollectionView, categoryCollectionView].forEach({$0?.delegate = self})
        [sliderCollectionView, categoryCollectionView].forEach({$0?.dataSource = self})
        sliderCollectionView.register(cellType: HomeSliderCollectionViewCell.self)
        categoryCollectionView.register(cellType: HomeCategoryCollectionViewCell.self)
        sliderCollectionView.isPagingEnabled = true
        [sliderCollectionView, categoryCollectionView].forEach({$0?.showsVerticalScrollIndicator = false})
        [sliderCollectionView, categoryCollectionView].forEach({$0?.showsHorizontalScrollIndicator = false})

    }
    @IBAction func logoButtonTapped(_ sender: UIButton) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    @IBAction func createStoreButtonTapped(_ sender: UIButton) {
        push(CreateStoreViewController())
    }
    @IBAction func notifyButtonTapped(_ sender: UIButton) {
        push(NotificationViewController())
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView {
            return viewModel.numberOfBanners
        }else{
            let count = viewModel.numberOfCategory
            return count + 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(with: HomeSliderCollectionViewCell.self, for: indexPath)
            cell.configCell(banner: viewModel.configBanners(at: indexPath.row))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(with: HomeCategoryCollectionViewCell.self, for: indexPath)
            if indexPath.row == 0 {
                cell.allCategoryView.isHidden = false
                cell.categoryView.isHidden = true
                cell.categoryNameLabel.text = AppStrings.categories.message
            }else{
                cell.allCategoryView.isHidden = true
                cell.categoryView.isHidden = false
                cell.configCell(category: viewModel.configCategory(at: indexPath.row))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sliderCollectionView{
            if let url = viewModel.configBanners(at: indexPath.row).url {
                openUrl(url: url)
            }
        }else if collectionView == categoryCollectionView{
            if indexPath.row == 0 {
                push(CategoryViewController())
            }else{
                let category = viewModel.configCategory(at: indexPath.row)
                push(SubCategoryViewController(categoryID: category.id ?? 0, categoryName: category.name ?? ""))
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderCollectionView {
            return CGSize(width: (collectionView.frame.width)  , height: sliderCollectionView.frame.height)
        }else{
            return CGSize(width: 85 , height: 130)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func pauseTimer() {
         timer?.invalidate()
         timer = nil
     }

     func resumeTimer() {
         pauseTimer()
         startTimer()
     }

     // MARK: - UIScrollViewDelegate

     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
         if scrollView == sliderCollectionView {
             pauseTimer()
         }
         // Pause timer when the user manually scrolls
     }

     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         // Resume timer after manual scroll is complete
         if scrollView == sliderCollectionView {
//             resumeTimer()
             let centerPoint = CGPoint(x: sliderCollectionView.bounds.midX, y: sliderCollectionView.bounds.midY)
             
             // Find the closest visible cell to the center
             if let centerIndexPath = sliderCollectionView.indexPathForItem(at: centerPoint) {
                 print("Center index path: \(centerIndexPath)")
                 currentPage = centerIndexPath.item
                 pageControl.currentPage = currentPage
                 startTimer()
//                 scrollToNextPage()
             }
         }else if scrollView == self.scrollView {
             let offsetY = scrollView.contentOffset.y
             let contentHeight = scrollView.contentSize.height
             let scrollViewHeight = scrollView.frame.size.height
             
             if offsetY > contentHeight - scrollViewHeight - 100 {  // Adjust the threshold as needed
                 print("the end")
                 Task {
                     await viewModel.getProducts()
                 }
             }else if offsetY < 50 {  // Adjust the threshold as needed
                 print("scrolled to the top")
                 Task {
//                     await viewModel.reloadData()
                     reloadData()
                 }
             }
         }

     }
    // MARK: - UIScrollViewDelegate
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         let offsetY = scrollView.contentOffset.y
//         let contentHeight = scrollView.contentSize.height
//         let scrollViewHeight = scrollView.frame.size.height
//         
//         if offsetY > contentHeight - scrollViewHeight - 100 {  // Adjust the threshold as needed
//             print("the end")
//         }
     }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductsTableViewCell.self, for: indexPath)
        let product = viewModel.configProducts(at: indexPath.row)
        cell.configCell(data: product)
        let isFavourite = product.isFavourite ?? false
        
        cell.loveButtonTapped = {[weak self] in
            if isFavourite{
                guard let self = self else{return}
                Task {
                    await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: 0)
                }
                viewModel.changeISFavorite(index: indexPath.row)
            }else{
                guard let self = self else{return}
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
        cell.addToCartButtonTapped = {[weak self] in
            guard let self = self else{return}
            Task {
                await self.viewModel.addToCart(productID: product.id ?? 0)
            }
        }
        cell.shareButtonTapped = {[weak self] in
            guard let self = self else{return}
            shareButtonTapped(shareLink: product.shareLink ?? "", productName: product.name ?? "", description: product.description ?? "")
        }
        cell.showStoreButtonTapped = {[weak self] in
            guard let self = self else{return}
            let storeID = product.store?.id ?? 0
            push(StoreDetailsViewController(storeID: storeID))
        }
        return cell
        
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.height
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(ProductDetailsViewController(productID: viewModel.configProducts(at: indexPath.row).id ?? 0, delegate: self))
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            if scrollView == tableView {
//                guard tableView.indexPathsForVisibleRows != nil else { return }
//                let centerPoint = CGPoint(x: tableView.bounds.midX, y: tableView.bounds.midY)
//                if let centerIndexPath = tableView.indexPathForRow(at: centerPoint) {
//                    print("Center index path: \(centerIndexPath.row)")
//                    let cell = getCell(from: centerIndexPath) as? ProductsTableViewCell
//                    cell?.stopAllVideos()
//    //                if centerIndexPath.row == viewModel.numberOfProducts - 3 {
//    //                    Task {
//    //                        await viewModel.getProducts()
//    //                    }
//    //                }
//
//                }
//            }
//        }
    }

    func getCell(from indexPath: IndexPath) -> UITableViewCell? {
           return tableView.cellForRow(at: indexPath)
       }
}
extension HomeViewController {
    func startTimer() {
        pauseTimer()
         timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
     }
    @objc func scrollToNextPage() {
        if viewModel.numberOfBanners != 0 {
            let nextPage = (currentPage + 1) % viewModel.numberOfBanners
            let indexPath = IndexPath(item: nextPage, section: 0)
            sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            currentPage = nextPage
            pageControl.currentPage = currentPage

        }

    }
}
// MARK: Binding

extension HomeViewController {
    private func bind() {
        getHomeData()
//        getBanners()
        bindLoadingIndicator()
        bindCategoryData()
        bindBannersData()
        bindProductsData()

    }
    private func getHomeData() {
        pauseTimer()
        Task {
            await viewModel.getBanners()
            await viewModel.getCategory()
            await viewModel.getProducts()

        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindCategoryData() {
        viewModel.$reloadCategory.sink { [weak self] status in
            guard let self, status else { return }
            categoryCollectionView.reloadData()
        }.store(in: &cancellable)
    }
    private func bindBannersData() {
        viewModel.$reloadBanners.sink { [weak self] status in
            guard let self, status else { return }
            sliderCollectionView.reloadData()
            pageControl.numberOfPages = viewModel.numberOfBanners
            startTimer()
        }.store(in: &cancellable)
    }
    private func bindProductsData() {
        viewModel.$reloadProducts.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
            setCartCount(cartCount: viewModel.cartCount)
        }.store(in: &cancellable)
    }
}
extension HomeViewController {
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
    private func setCreateStoreButton(){
        let userType = UserDefaults.userData?.role ?? .user
        if userType == .store {
            createStoreButton.isHidden = true
        }else{
            createStoreButton.isHidden = false
        }

    }
}
extension HomeViewController: SelectFavoriteFileID{
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        let product = viewModel.configProducts(at: index)
        Task {
            await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: id)
        }
        viewModel.changeISFavorite(index: index)

    }
    
}
extension HomeViewController: UpdateProductDetailsFavoriteAction{
    func updateProductDetailsFavoriteAction(productId: Int, isChanged: Bool) {
        guard let index = viewModel.productsArray.firstIndex(where: {$0.id == productId}) else { return  }
      let indexPath = IndexPath(row: index, section: 0)

        if isChanged{
            viewModel.changeISFavorite(index: index)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
}
