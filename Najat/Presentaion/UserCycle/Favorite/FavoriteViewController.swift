//
//  FavoriteViewController.swift
//  Najat
//
//  Created by rania refaat on 03/07/2024.
//

import UIKit

class FavoriteViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel: FavoriteViewModel = {
        FavoriteViewModel(coordinator: coordinator)
    }()
    
    private var fileID: Int
    private var fileName: String

    init(fileID: Int, fileName: String) {
        self.fileID = fileID
        self.fileName = fileName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifyButton()
        setupTableView()
        setTitle(fileName)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
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
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductsTableViewCell.self, for: indexPath)
        
        let product = viewModel.configProducts(at: indexPath.row)
        cell.configCell(data: product)

        cell.loveButtonTapped = {[weak self] in
            guard let self = self else{return}
//            let vc = AddToFavoriteListViewController(delegate: self, index: indexPath.row)
//            if #available(iOS 15.0, *) {
//                if let sheet = vc.sheetPresentationController {
//                    sheet.detents = [.medium(), .large()]
//                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                    sheet.prefersGrabberVisible = true
//                    sheet.largestUndimmedDetentIdentifier = .medium
//                    sheet.preferredCornerRadius = 20
//                    sheet.prefersEdgeAttachedInCompactHeight = true
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//            self.present(vc, animated: true, completion: nil)
            let product = viewModel.configProducts(at: indexPath.row)
            Task {
                await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: self.fileID)
            }
            viewModel.changeISFavorite(index: indexPath.row)

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
//        return 500
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(ProductDetailsViewController(productID: viewModel.configProducts(at: indexPath.row).id ?? 0, delegate: nil))
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfProducts - 3 {
            Task {
                await viewModel.getFavorites(fileID: fileID)
            }
        }
    }
}
// MARK: Binding
extension FavoriteViewController {
    private func bind() {
        getProducts()
        bindLoadingIndicator()
        bindProductsData()
    }
    private func getProducts() {
        Task {
            await viewModel.getFavorites(fileID: fileID)
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
extension FavoriteViewController: SelectFavoriteFileID{
    func selectFavoriteFileID(_ id: Int, _ index: Int) {
        let product = viewModel.configProducts(at: index)
        Task {
            await self.viewModel.addToFavorite(productID: product.id ?? 0, fileID: id)
        }
        viewModel.changeISFavorite(index: index)

    }
    
}
