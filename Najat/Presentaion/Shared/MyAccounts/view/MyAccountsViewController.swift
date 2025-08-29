//
//  MyAccountsViewController.swift
//  Najat
//
//  Created by rania refaat on 19/08/2024.
//

import UIKit

class MyAccountsViewController: BaseController {

    // MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    //        @IBOutlet weak var titleLabel: UILabel!
    
    // MARK:- Variables
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    private var userAccountsArray = [UserAccounts]()
    
    private lazy var viewModel: MyAccountsViewModel = {
        MyAccountsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        getUserData()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MyAccountsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    func startInteractiveTransition(state: CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            //            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismissMe()
    }
    private func getUserData(){
        let userData = UserDefaults.userData
        let userType = userData?.role ?? .user
        userAccountsArray.append(UserAccounts(name: userData?.name ?? "", image: userData?.image ?? "", id: userData?.id ?? 0, isCurrent: true, type: userType))
        switch userType {
        case .user:
            for item in userData?.stores ?? []{
                userAccountsArray.append(UserAccounts(name: item.name ?? "", image: item.image ?? "", id: item.id ?? 0, isCurrent: false, type: .store))
            }
        case .store:
            guard  let user = userData?.user else{return}
            userAccountsArray.append(UserAccounts(name: user.name ?? "", image: user.image ?? "", id: user.id ?? 0, isCurrent: false, type: .user))
            for item in userData?.user?.stores ?? []{
                if item.id != userData?.id {
                    userAccountsArray.append(UserAccounts(name: item.name ?? "", image: item.image ?? "", id: item.id ?? 0, isCurrent: false, type: .store))
                }
            }
        }
        tableView.reloadData()
    }
}
extension MyAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAccountsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MyAccountsTableViewCell.self, for: indexPath)
        cell.userNameLabel.text = userAccountsArray[indexPath.row].name
        cell.userImageView.load(with: userAccountsArray[indexPath.row].image)
        let isCurrent = userAccountsArray[indexPath.row].isCurrent
        if isCurrent {
            cell.selectImageView.isHidden = false
        }else{
            cell.selectImageView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            let id = userAccountsArray[indexPath.row].id
            await viewModel.attemptSwitchAccount(accountID: id)
        }
    }
    
}
extension MyAccountsViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.containerView.bounds.contains(touch.location(in: self.containerView)) {
            return false
        }
        return true
    }
}
// MARK: Binding

extension MyAccountsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindSwitchAccounts()
    }
    
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindSwitchAccounts() {
        viewModel.switchAccountState.sink { [weak self] in
            guard let self else { return }
            AppWindowManger.openTabBar()
        }.store(in: &cancellable)
    }
}

struct UserAccounts{
    var name: String
    var image: String
    var id: Int
    var isCurrent: Bool
    var type: UserType
}
