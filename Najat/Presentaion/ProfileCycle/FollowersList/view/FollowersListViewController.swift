//
//  FollowersListViewController.swift
//  Najat
//
//  Created by rania refaat on 04/09/2024.
//

import UIKit

class FollowersListViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: FollowersListViewModel = {
        FollowersListViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setTitle(AppStrings.Followers.message)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // or any appropriate value
        
        bind()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FollowedStoresTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
    }
    
}
extension FollowersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFollowers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FollowedStoresTableViewCell.self, for: indexPath)
        
        let store = viewModel.configFollowers(at: indexPath.row)
        cell.configCell(data: store)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = viewModel.configFollowers(at: indexPath.row)
        
//        push(StoreDetailsViewController(storeID: store.id ?? 0))
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
                    await self.viewModel.deleteFollower(index:indexPath.row)
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
// MARK: Binding
extension FollowersListViewController {
    private func bind() {
        getFollowers()
        bindLoadingIndicator()
        bindStoresData()
    }
    private func getFollowers() {
        Task {
            await viewModel.getFollowers()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindStoresData() {
        viewModel.$reloadFollowers.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}
