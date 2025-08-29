//
//  MainProfileViewController.swift
//  Najat
//
//  Created by rania refaat on 30/07/2024.
//

import UIKit

class MainProfileViewController: UIViewController {

    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    var selectTapped : ((_ type: ProfileType)->Void)?

    private var profileDataArray : [ProfileData] = [
        ProfileData(title: AppStrings.settings.message, profileType: .settings, profileImages: .settings),
        ProfileData(title: AppStrings.address.message, profileType: .address, profileImages: .address),
        ProfileData(title: AppStrings.orders.message, profileType: .orders, profileImages: .orders),
        ProfileData(title: AppStrings.privacy.message, profileType: .privacy, profileImages: .privacy),
        ProfileData(title: AppStrings.terms.message, profileType: .condition, profileImages: .terms),
        ProfileData(title: AppStrings.contactUS.message, profileType: .contactUS, profileImages: .contact),
        ProfileData(title: AppStrings.question.message, profileType: .questions, profileImages: .questions)

        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let userType = UserDefaults.userData?.role ?? .user
        if userType == .user {
            profileDataArray.insert( ProfileData(title: AppStrings.createStore.message, profileType: .createStore, profileImages: .createStore), at: 1)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        
        tableHeight.constant = tableView.contentSize.height
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.updateViewConstraints()
            self?.loadViewIfNeeded()
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MainProfileTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss()
    }
    @IBAction func logoutButtonTapped(_ sender: AppFontButton) {
        selectTapped?(.logout)
        dismissMe()
    }
    @IBAction func deleteAccountButtonTapped(_ sender: AppFontButton) {
        deleteAccountAlert()
    }
    private func deleteAccountAlert(){
        let alert = UIAlertController(title: AppStrings.Alert.message, message: AppStrings.deleteAccount.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppStrings.no.message, style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: AppStrings.yes.message, style: .default, handler: { action in
            self.selectTapped?(.deleteAccount)
            self.dismissMe()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
extension MainProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MainProfileTableViewCell.self, for: indexPath)
        cell.configCell(data: profileDataArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = profileDataArray[indexPath.row].profileType ?? .aboutApp
        selectTapped?(type)
        dismissMe()
    }
    
}
enum ProfileImages: String{
    case settings = "nSettings"
    case address = "address"
    case privacy = "privacy"
    case contact = "contact"
    case questions = "questions"
    case terms = "terms"
    case orders = "orders"
    case createStore = "store"
}
struct ProfileData{
    let title: String
    let profileType: ProfileType
    let profileImages: ProfileImages
}
enum ProfileType{
    case settings
    case address
    case orders
    case questions
    case condition
    case privacy
    case contactUS
    case aboutApp
case logout
    case deleteAccount
    case createStore
}
