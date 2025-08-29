//
//  UserMainProfileViewController.swift
//  Najat
//
//  Created by rania refaat on 31/08/2024.
//

import UIKit

class UserMainProfileViewController: BaseController {

    @IBOutlet weak var nameLabel: AppFontLabel!
    @IBOutlet weak var bioLabel: AppFontLabel!
    @IBOutlet weak var name2Label: AppFontLabel!
    @IBOutlet weak var likesNumberLabel: AppFontLabel!
    @IBOutlet weak var storeNumberLabel: AppFontLabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    private lazy var viewModel: UserMainProfileViewModel = {
        UserMainProfileViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(status: true)
        Task {
            await viewModel.getProfileData()
        }
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar(status: false)

    }
    @IBAction func createStoreButtonTapped(_ sender: AppFontButton) {
        push(CreateStoreViewController())
    }
    @IBAction func shareProfileButtonTapped(_ sender: AppFontButton) {
    }
    @IBAction func editProfileButtonTapped(_ sender: AppFontButton) {
        push(UpdateUserProfileViewController())
    }
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        let vc = MainProfileViewController()
        vc.selectTapped = { type in
            switch type {
            case .settings:
                self.push(SettingsViewController())
            case .address:
                self.push(AddressListViewController())
            case .orders:
                self.push(UserOrdersListViewController())
            case .questions:
                self.push(QuestionsViewController())
            case .condition:
                self.push(TermsViewController())
            case .privacy:
                self.push(PrivacyViewController())
            case .contactUS:
                self.push(ContactUSViewController())
            case .createStore:
                self.push(CreateStoreViewController())
            case .aboutApp:
                print("")
            case .logout, .deleteAccount:
                Task {
                    await self.viewModel.logout()
                }
            }
        }
        customPresent(vc)
    }
    private func deleteAccountAlert(){
        let alert = UIAlertController(title: AppStrings.Alert.message, message: AppStrings.deleteAccount.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppStrings.no.message, style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: AppStrings.yes.message, style: .default, handler: { action in
            Task {
                await self.viewModel.logout()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func switchAccountsButtonTapped(_ sender: UIButton) {
        let vc = MyAccountsViewController()
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
    @IBAction func storesButtonTapped(_ sender: UIButton) {
        push(FollowedStoresListViewController())
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        tabBar?.selectedIndex = 1
    }
    
}
extension UserMainProfileViewController {
    private func setUserData(){
        guard let userData = UserDefaults.userData else{return}
        nameLabel.text = userData.name
        name2Label.text = userData.name
        userImageView.load(with: userData.image)
        likesNumberLabel.text = "\(userData.productsCount ?? 0)"
        storeNumberLabel.text = "\(userData.followings ?? 0)"
        bioLabel.text = userData.bio

    }
}
// MARK: Binding

extension UserMainProfileViewController {
    private func bind() {
        bindLoadingIndicator()
        bindUserDataData()
        bindUserLogoutData()
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindUserDataData() {
        viewModel.setUserDataState.sink { [weak self] in
            guard let self else { return }
            setUserData()
        }.store(in: &cancellable)
    }
    private func bindUserLogoutData() {
        viewModel.$setUserLogoutDataState.sink { [weak self] status in
            guard let self , status else { return }
            AppDelegate.shared.setRoot()
        }.store(in: &cancellable)
    }
}
