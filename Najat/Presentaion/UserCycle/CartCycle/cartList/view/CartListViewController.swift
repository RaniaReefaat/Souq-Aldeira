//
//  CartListViewController.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class CartListViewController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: CartListViewModellProtocol = {
        CartListViewModel(coordinator: coordinator)
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindUI()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartListRequest()
    }
}

private extension CartListViewController {
    
    func setupView() {
        addNotifyButton()
        setupTableView()
        setTitle(AppStrings.cart.message)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CartListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        CartListCell(at: indexPath)        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.storeID(at: indexPath.row)
        push(CartDetailsViewController(cartID: id))
    }
    
    func CartListCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CartListTableViewCell.self, for: indexPath)
        let cellData = viewModel.cellData(at: indexPath.row)
        cell.configCell(with: cellData)
        cell.actionShowCart = {[weak self] in
            guard let self else { return }
            let id = viewModel.storeID(at: indexPath.row)
            push(CartDetailsViewController(cartID: id))
        }
        return cell
    }

}

private extension CartListViewController {
    
    func bindUI() {
        bindLoading()
        bindReloadViews()
        bindShowEmptyView()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            $0 ? self?.startLoading() : self?.stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindReloadViews() {
        viewModel.uiModel.$reloadViews.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
            setCartCount(cartCount: viewModel.uiModel.cartCount)
        }.store(in: &cancellable)
    }
    
    func bindShowEmptyView() {
        viewModel.uiModel.$showEmptyView.sink { [weak self] in
            guard let self else { return }
            
            $0 ? self.showEmptyView(with: .cart) : self.removeEmptyView()
        }.store(in: &cancellable)
    }
}
extension CartListViewController {
    private func setCartCount(cartCount: Int){
        print(cartCount)
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
private extension CartListViewController {
    
    func getCartListRequest() {
        Task {
            await viewModel.getCartListRequest()
        }
    }
    
}
