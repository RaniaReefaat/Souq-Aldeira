//
//  AddToFavoriteListViewController.swift
//  Najat
//
//  Created by rania refaat on 14/11/2024.
//

import UIKit

class AddToFavoriteListViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    private lazy var viewModel: FavoriteFoldersListViewModel = {
        FavoriteFoldersListViewModel(coordinator: coordinator)
    }()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    private var delegate: SelectFavoriteFileID
    private var index: Int

    init(delegate: SelectFavoriteFileID, index: Int) {
        self.delegate = delegate
        self.index = index

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    @IBAction func dismissButtonTapped(_ sender: AppFontButton) {
        dismissMe()
    }
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
//            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
}
extension AddToFavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
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
        delegate.selectFavoriteFileID(file.id ?? 0, self.index)
        dismissMe()
    }
    
}
// MARK: Binding
extension AddToFavoriteListViewController {
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
extension AddToFavoriteListViewController: UpdateFavoriteFolderList{
    func updateFavoriteFolderList() {
        bind()
    }
}
extension AddToFavoriteListViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.containerView.bounds.contains(touch.location(in: self.containerView)) {
            return false
        }
        return true
    }
}
protocol SelectFavoriteFileID {
    func selectFavoriteFileID(_ id: Int, _ index: Int)
}
