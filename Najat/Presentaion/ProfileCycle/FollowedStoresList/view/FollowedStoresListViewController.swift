//
//  FollowedStoresListViewController.swift
//  Najat
//
//  Created by rania refaat on 02/08/2024.
//

import UIKit

class FollowedStoresListViewController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: FollowedStoresListViewModel = {
        FollowedStoresListViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let userData = UserDefaults.userData
        let userType = userData?.role ?? .user
        switch userType {
        case .user:
            setTitle(AppStrings.FollowedStores.message)
        case .store:
            setTitle(AppStrings.Followed.message)
        }
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
extension FollowedStoresListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfStores
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FollowedStoresTableViewCell.self, for: indexPath)
        
        let store = viewModel.configStores(at: indexPath.row)
        cell.configCell(data: store)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = viewModel.configStores(at: indexPath.row)
        
        push(StoreDetailsViewController(storeID: store.id ?? 0))
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        //           let isRead = itemCellList[indexPath.row].isRead
        let title =  AppStrings.unfollow.message
        let readAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self] (_, _, completionHandler) in
                guard let self = self else{return}
                Task {
                    let id = self.viewModel.configStores(at: indexPath.row).id ?? 0
                    await self.viewModel.addToUnFollow(storeID:id)
                }
                completionHandler(true)
            }
        )
        let readLabel = UILabel()
        readLabel.text = title
        readLabel.font = .regularFont(of: 12)
        readLabel.sizeToFit()
        readLabel.textColor = .white
        
        readAction.image = addLabelToImage(image: UIImage(named: "trashN")!, label: readLabel)
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
extension FollowedStoresListViewController {
    private func bind() {
        getStores()
        bindLoadingIndicator()
        bindStoresData()
    }
    private func getStores() {
        Task {
            await viewModel.getStores()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindStoresData() {
        viewModel.$reloadStores.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}
extension UIViewController {
    func addLabelToImage(image: UIImage, label: UILabel) -> UIImage? {
        let tempView = UIStackView(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.height))
        imageView.contentMode = .scaleAspectFit
        tempView.axis = .vertical
        tempView.alignment = .center
        tempView.spacing = 8
        imageView.image = image
        tempView.addArrangedSubview(imageView)
        tempView.addArrangedSubview(label)
        let renderer = UIGraphicsImageRenderer(bounds: tempView.bounds)
        let image = renderer.image { rendererContext in
            tempView.layer.render(in: rendererContext.cgContext)
        }
        return image
    }
}
