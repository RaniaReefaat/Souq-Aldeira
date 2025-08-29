//
//  UserOrdersListViewController.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import UIKit

class UserOrdersListViewController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: UserOrderListViewModel = {
        UserOrderListViewModel(coordinator: coordinator)
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTitle(AppStrings.orders.message)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        bindUI()
    }
}

private extension UserOrdersListViewController {
    
    func setupView() {
        addNotifyButton()
        setupTableView()
        setTitle(AppStrings.cart.message)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: UserOrdersListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
}

extension UserOrdersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        OrderListCell(at: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.cellData(at: indexPath.row).id ?? 0
        push(UserOrderDetailsViewController(orderID: id))
    }
    
    func OrderListCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: UserOrdersListTableViewCell.self, for: indexPath)
        let cellData = viewModel.cellData(at: indexPath.row)
        cell.configCell(order: cellData)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows - 3 {
            Task {
                await viewModel.getOrders()
            }
        }
    }

}

private extension UserOrdersListViewController {
    
    func bindUI() {
        getOrders()
        bindLoading()
        bindReloadViews()
        bindShowEmptyView()
    }
    func bindReloadViews() {
        viewModel.$reloadData.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    func bindShowEmptyView() {
        viewModel.$showEmptyView.sink { [weak self] in
            guard let self else { return }
            
            $0 ? self.showEmptyView(with: .orders) : self.removeEmptyView()
        }.store(in: &cancellable)
    }
    private func bindLoading() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
}
private extension UserOrdersListViewController {
    
    func getOrders() {
        Task {
             await viewModel.getOrders()
        }
    }
    
}
