//
//  UpdateStoreProfileViewController.swift
//  Najat
//
//  Created by rania refaat on 18/09/2024.
//

import UIKit
import YPImagePicker

class UpdateStoreProfileViewController: BaseController {

    @IBOutlet weak var infoTV: AppFontTextView!
    @IBOutlet weak var phoneTF: AppFontTextField!
    @IBOutlet weak var nameTF: AppFontTextField!
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var deliveryPriceTF: AppFontTextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTF: AppFontTextField!

    private var image: Data?
    private let pricesPicker = DataPicker()

    private lazy var viewModel: UpdateStoreProfileViewModel = {
        UpdateStoreProfileViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserProfileData()
        setTitle(AppStrings.updateProfile.message)
        bind()
        setupPricesPickers()
    }
    private func setupPricesPickers() {
        pricesPicker.initPickerView(txtField: deliveryPriceTF, view: view) { [weak self] index in
            guard let self = self else {return}
            guard let index = index else {return}
            let item = self.viewModel.pricesArray[index]
            self.deliveryPriceTF.text = item
        }
    }
    @IBAction func updateImageButtonTapped(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                let selectedImage = photo.image
                let imageData = selectedImage.toData()
                self.profileImageView.image = selectedImage
                self.image = imageData
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        var phone = phoneTF.text ?? ""
        var name = nameTF.text ?? ""
        var desc = infoTV.text ?? ""
        var email = emailTF.text ?? ""
        var price = deliveryPriceTF.text ?? ""

        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        guard let userData = UserDefaults.userData else{return}
        let body = UpdateUserProfileBody(phone: nil, name: name, bio: desc , receive_notifications: userData.receiveNotifications ?? false ? 1 : 0, lang: userData.lang, email: email, delivery_fee: price, whatsapp: newStr)
        let myImage = profileImageView.image?.jpegData(compressionQuality: 0.4)

        Task {
            await viewModel.attemptUpdateProfile(body: body, image: self.image)
        }
        
    }
}
extension UpdateStoreProfileViewController{
    private func setUserProfileData(){
        guard let userData = UserDefaults.userData else{return}

        profileImageView.load(with: userData.image)
        nameLabel.text = userData.name
        phoneTF.text = userData.whatsapp
        nameTF.text = userData.name
        infoTV.text = userData.bio
        deliveryPriceTF.text = userData.delivery_fee
        emailTF.text = userData.email
    }
}
// MARK: Binding

extension UpdateStoreProfileViewController {
    private func bind() {
        bindLoadingIndicator()
        bindCreateSuccess()
        bindPricesData()
        Task {
            await viewModel.getDeliveryPrice()
        }

    }
    
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindCreateSuccess() {
        viewModel.successUpdateProfileState.sink { [weak self] in
            guard let self else { return }
            popToRoot()
        }.store(in: &cancellable)
    }
    private func bindPricesData() {
        viewModel.$reloadPrices.sink { [weak self] status in
            guard let self, status else { return }
            pricesPicker.array = viewModel.pricesArray
        }.store(in: &cancellable)
    }
}
