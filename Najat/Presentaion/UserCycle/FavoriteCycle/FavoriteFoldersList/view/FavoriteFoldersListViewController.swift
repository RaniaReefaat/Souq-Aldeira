//
//  FavoriteFoldersListViewController.swift
//  Najat
//
//  Created by rania refaat on 14/11/2024.
//

import UIKit

class FavoriteFoldersListViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel: FavoriteFoldersListViewModel = {
        FavoriteFoldersListViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addNotifyButton()
        setTitle(AppStrings.Likes.message)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bind()

    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FavoriteFoldersListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
    }
    @IBAction func addFolderButtonTapped(_ sender: AppFontButton) {
        customPresent(AddFavoriteFolderViewController(delegate: self))
    }
}
extension FavoriteFoldersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFiles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FavoriteFoldersListTableViewCell.self, for: indexPath)
        cell.nameLabel.text = viewModel.configFiles(at: indexPath.row).name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = viewModel.configFiles(at: indexPath.row)
        
        push(FavoriteViewController(fileID: file.id ?? 0, fileName: file.name ?? ""))
    }
    
}
// MARK: Binding
extension FavoriteFoldersListViewController {
    private func bind() {
        getFolderList()
        bindLoadingIndicator()
        bindListData()
    }
    private func getFolderList() {
        Task {
            await viewModel.getFavoritesFilesList()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindListData() {
        viewModel.$reloadList.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}
extension FavoriteFoldersListViewController: UpdateFavoriteFolderList{
    func updateFavoriteFolderList() {
        bind()
    }
}
