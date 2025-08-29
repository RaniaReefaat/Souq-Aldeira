//
//  NotificationViewController.swift
//  Edrak
//
//  Created by rania refaat on 25/08/2023.
//

import UIKit

class NotificationViewController: BaseController {

    @IBOutlet weak var tableView: TableViewWithLoading!
    

    private lazy var viewModel: NotificationViewModel = {
        NotificationViewModel(coordinator: coordinator)
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(AppStrings.notifications.message)
        setupTableView()
        bindData()
        setupNotificationsPagination()


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: NotificationTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    private func setupNotificationsPagination() {
        tableView.onRefresh = { [weak self] in
            guard let self else { return }
            tableView.pageNumber = 1
            fetchNotifications(page: tableView.pageNumber)
        }

        tableView.onGetNewPage = { [weak self] in
            guard let self else { return }
            guard viewModel.lastPage != tableView.pageNumber else { return }
            tableView.isLoading = true
            tableView.pageNumber += 1
            fetchNotifications(page: tableView.pageNumber)
        }
    }
}
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfNotifications
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NotificationTableViewCell.self, for: indexPath)
        guard let data = viewModel.cellData(at: indexPath.row).data else{ return cell}
        cell.configCell(data: data )
        return cell
    }
}
private extension NotificationViewController {

    func bindData() {
        fetchNotifications(page: 1)
        bindLoading()
        bindReloadViews()
        bindEmptyState()
    }

    func fetchNotifications(page: Int) {
        Task {
            await viewModel.fetchNotifications(page: page)
        }
    }

    
    func bindLoading() {
        viewModel.$isLoading.sink { [weak self] status in
            guard let self else { return }
            status ? startLoading() : stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindReloadViews() {
        viewModel.$reloadViews.sink { [weak self] status in
            guard let self, status else { return }
            tableView.isLoading = false
            tableView.fetchData()
            tableView.reloadData()
        }.store(in: &cancellable)
    }

    func bindEmptyState() {
        viewModel.$showEmptyState.sink { [weak self] status in
            guard let self else { return }
//            emptyStateView.isHidden = !status
        }.store(in: &cancellable)
    }
}//        viewModel.numberOfNotifications

