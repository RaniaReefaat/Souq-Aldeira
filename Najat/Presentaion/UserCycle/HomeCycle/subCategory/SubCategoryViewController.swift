//
//  SubCategoryViewController.swift
//  Najat
//
//  Created by rania refaat on 17/07/2024.
//

import UIKit

class SubCategoryViewController: BaseController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel: SubcategoryViewModel = {
        SubcategoryViewModel(coordinator: coordinator)
    }()
    
    private var categoryID: Int
    private var categoryName: String

    init(categoryID: Int, categoryName: String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
        setTitle(categoryName)
        bind()
        
    }
    private func setupCollectionView() {
        [collectionView].forEach({$0?.delegate = self})
        [collectionView].forEach({$0?.dataSource = self})
        collectionView.register(cellType: HomeCategoryCollectionViewCell.self)
        [collectionView].forEach({$0?.showsVerticalScrollIndicator = false})
        [collectionView].forEach({$0?.showsHorizontalScrollIndicator = false})
        
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ProductsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
    }

}
extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductsTableViewCell.self, for: indexPath)
        
        let product = viewModel.configProducts(at: indexPath.row)
        cell.configCell(data: product)
        let isFavourite = product.isFavourite ?? false
        
        cell.loveButtonTapped = {[weak self] in
            guard let self = self else{return}
            if isFavourite{
                Task {
                    await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: 0)
                }
                viewModel.changeISFavorite(index: indexPath.row)
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
        cell.addToCartButtonTapped = {[weak self] in
            guard let self = self else{return}
            Task {
                await self.viewModel.addToCart(productID: product.id ?? 0)
            }
        }
        return cell
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 500
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(ProductDetailsViewController(productID: viewModel.configProducts(at: indexPath.row).id ?? 0, delegate: nil))
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfProducts - 3 {
            Task {
                await viewModel.getProducts(categoryID: categoryID)
            }
        }
    }
}
extension SubCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSubCategory
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HomeCategoryCollectionViewCell.self, for: indexPath)
        cell.allCategoryView.isHidden = true
        cell.categoryView.isHidden = false
        cell.configCell(category: viewModel.configSubCategory(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subcategory = viewModel.configSubCategory(at: indexPath.row)
        push(ProductsViewController(subCategoryID: subcategory.id ?? 0, subCategoryName: subcategory.name ?? ""))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85 , height: 130)

    }
}
extension SubCategoryViewController {
    private func bind() {
        getSubCategory()
        bindLoadingIndicator()
        bindCategoryData()
        getProducts()
        bindProductsData()
        bindCartCount()
        bindShowEmptyView()

    }
    func bindShowEmptyView() {
        viewModel.$showEmptyView.sink { [weak self] in
            guard let self else { return }
            
            $0 ? self.showEmptyView(with: .products) : self.removeEmptyView()
        }.store(in: &cancellable)
    }
    private func getSubCategory() {
        Task {
            await viewModel.getSubCategory(categoryID)
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindCategoryData() {
        viewModel.$reloadSubCategory.sink { [weak self] status in
            guard let self, status else { return }
            collectionView.reloadData()
            
        }.store(in: &cancellable)
    }
    private func getProducts() {
        Task {
            await viewModel.getProducts(categoryID: categoryID)
        }
    }
    private func bindProductsData() {
        viewModel.$reloadProducts.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    private func bindCartCount() {
        viewModel.$cartCount.sink { [weak self] count in
            guard let self else { return }
            setCartCount(cartCount: count)
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
}
extension SubCategoryViewController: SelectFavoriteFileID{
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        let product = viewModel.configProducts(at: index)
        Task {
            await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: id)
        }
        viewModel.changeISFavorite(index: index)

    }
    
}
