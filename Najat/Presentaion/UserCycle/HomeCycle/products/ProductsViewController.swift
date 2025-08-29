//
//  ProductsViewController.swift
//  Najat
//
//  Created by rania refaat on 17/07/2024.
//

import UIKit

class ProductsViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel: ProductsViewModel = {
        ProductsViewModel(coordinator: coordinator)
    }()
    
    private var subCategoryID: Int
    private var subCategoryName: String

    init(subCategoryID: Int, subCategoryName: String) {
        self.subCategoryID = subCategoryID
        self.subCategoryName = subCategoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setTitle(subCategoryName)
        bind()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ProductsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
    }

}
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
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
                await viewModel.getProducts(subCategoryID: subCategoryID)
            }
        }
    }
}
// MARK: Binding
extension ProductsViewController {
    private func bind() {
        getProducts()
        bindLoadingIndicator()
        bindProductsData()
        bindShowEmptyView()

    }
    func bindShowEmptyView() {
        viewModel.$showEmptyView.sink { [weak self] in
            guard let self else { return }
            
            $0 ? self.showEmptyView(with: .products) : self.removeEmptyView()
        }.store(in: &cancellable)
    }
    private func getProducts() {
        Task {
            await viewModel.getProducts(subCategoryID: subCategoryID)
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
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}
extension ProductsViewController: SelectFavoriteFileID{
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        let product = viewModel.configProducts(at: index)
        Task {
            await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: id)
        }
        viewModel.changeISFavorite(index: index)

    }
    
}
