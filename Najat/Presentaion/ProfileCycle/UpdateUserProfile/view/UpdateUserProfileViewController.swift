//
//  UpdateUserProfileViewController.swift
//  Najat
//
//  Created by rania refaat on 28/08/2024.
//

import UIKit
import YPImagePicker

class UpdateUserProfileViewController: BaseController {

    @IBOutlet weak var infoTV: AppFontTextView!
    @IBOutlet weak var phoneTF: AppFontTextField!
    @IBOutlet weak var nameTF: AppFontTextField!
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!

    private var image: Data?

    private lazy var viewModel: UpdateUserProfileViewModel = {
        UpdateUserProfileViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserProfileData()
        setTitle(AppStrings.updateProfile.message)
        bind()

    }
    @IBAction func updatePhoneButtonTapped(_ sender: UIButton) {
        push(UpdateProfilePhoneViewController(phone: phoneTF.text ?? ""))
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
        
        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        guard let userData = UserDefaults.userData else{return}
        let body = UpdateUserProfileBody(phone: newStr, name: name, bio: desc , receive_notifications: userData.receiveNotifications ?? false ? 1 : 0, lang: userData.lang ?? "")
        let myImage = profileImageView.image?.jpegData(compressionQuality: 0.4)

        Task {
            await viewModel.attemptUpdateProfile(body: body, image: myImage ?? Data())
        }
        
    }
}
extension UpdateUserProfileViewController{
    private func setUserProfileData(){
        guard let userData = UserDefaults.userData else{return}

        profileImageView.load(with: userData.image)
        nameLabel.text = userData.name
        phoneTF.text = userData.phone
        nameTF.text = userData.name
        infoTV.text = userData.bio
    }
}
// MARK: Binding

extension UpdateUserProfileViewController {
    private func bind() {
        bindLoadingIndicator()
        bindCreateSuccess()   
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
}
