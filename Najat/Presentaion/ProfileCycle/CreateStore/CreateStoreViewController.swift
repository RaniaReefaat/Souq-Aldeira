//
//  CreateStoreViewController.swift
//  Najat
//
//  Created by rania refaat on 05/08/2024.
//

import UIKit
import YPImagePicker
import UniformTypeIdentifiers

class CreateStoreViewController: BaseController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var deliveryPriceTF: AppFontTextField!
    @IBOutlet weak var descriptionTV: AppFontTextView!
    @IBOutlet weak var emailTF: AppFontTextField!
    @IBOutlet weak var whatsAppNumberTF: AppFontTextField!
    @IBOutlet weak var nameTF: AppFontTextField!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var licenseNameLabel: AppFontLabel!

    private var image: Data?
    private var license: Data?
    private var licenseISFile = false
    
    private let pricesPicker = DataPicker()

    private lazy var viewModel: CreateStoreViewModel = {
        CreateStoreViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupPricesPickers()
        setTitle(AppStrings.createStore.message)
    }
    private func setupPricesPickers() {
        pricesPicker.initPickerView(txtField: deliveryPriceTF, view: view) { [weak self] index in
            guard let self = self else {return}
            guard let index = index else {return}
            let item = self.viewModel.pricesArray[index]
            self.deliveryPriceTF.text = item
        }
    }
    @IBAction func licenseButtonTapped(_ sender: UIButton) {
        customPresent(UploadOptionsViewController(delegate: self))
    }
    @IBAction func storeImageButtonTapped(_ sender: UIButton) {
        var config = YPImagePickerConfiguration()
        config.library.defaultMultipleSelection = false
//        config.library.maxNumberOfItems = 10
//        config.library.minNumberOfItems = 1
//        config.library.numberOfItemsInRow = 4
//        config.library.spacingBetweenItems = 1.0
//        config.screens = [.library]
//        config.library.mediaType = .photo
        config.library.onlySquare = true
        config.library.isSquareByDefault = true
        config.showsCrop = .rectangle(ratio: 1.0) // Set the desired aspect ratio (e.g., 1.0 for square)

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                let selectedImage = photo.image
                let imageData = selectedImage.toData()
                self.storeImageView.image = selectedImage
                self.image = imageData
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        attemptCreateStore()
    }
}
extension CreateStoreViewController{
    private func openFileSelection(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    private func openImagesSelection(){
        var config = YPImagePickerConfiguration()
        config.library.defaultMultipleSelection = false
        config.library.onlySquare = true
        config.library.isSquareByDefault = true
        config.showsCrop = .rectangle(ratio: 1.0) // Set the desired aspect ratio (e.g., 1.0 for square)
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                let selectedImage = photo.image
                let imageData = selectedImage.toData()
                self.licenseImageView.image = selectedImage
                self.license = imageData
                self.licenseISFile = false
                self.licenseNameLabel.text = "Store License File".localized

            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}
extension CreateStoreViewController: UploadOptionsSelected {
    func passUploadOptions(option: UploadOptions) {
        switch option {
        case .file:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.openFileSelection()
            }
        case .image:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.openImagesSelection()
            }
        }
    }
}
extension CreateStoreViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let selectedFileURL = urls.first else {
            print("No file selected")
            return
        }
        guard selectedFileURL.startAccessingSecurityScopedResource() else {
            return
        }

        defer {
            selectedFileURL.stopAccessingSecurityScopedResource()
        }
        // You can now use the selectedFileURL for your upload logic
        print("Selected File URL: \(selectedFileURL)")
        
        do {
            let fileData = try Data(contentsOf: selectedFileURL)
            
            // You can now use the fileData for your upload logic
            print("File Data: \(fileData)")
            self.license = fileData
            self.licenseISFile = true
            self.licenseImageView.image = nil
            licenseNameLabel.text = selectedFileURL.lastPathComponent
        } catch {
            print("Error reading file data: \(error.localizedDescription)")
        }
        
    }
    
    // UIDocumentPickerDelegate method
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}
// MARK: Input
extension CreateStoreViewController {
    private func attemptCreateStore() {
        var phone = whatsAppNumberTF.text ?? ""
        var name = nameTF.text ?? ""
        var desc = descriptionTV.text ?? ""
        var price = deliveryPriceTF.text ?? ""
        var email = emailTF.text ?? ""

        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        let body = CreateStoreBody(
            whatsapp: newStr,
            name: name,
            bio: desc,
            email: email,
            delivery_fee: price
        )
        
        let myImage = storeImageView.image?.jpegData(compressionQuality: 0.4)
        if licenseISFile {
            Task {
                await viewModel.attemptCreateStore(body: body, image: myImage ?? Data(), license: self.license ?? Data(), licenseISFile: licenseISFile)
            }
        }else{
            let licenseImage = licenseImageView.image?.jpegData(compressionQuality: 0.4)
            
            Task {
                await viewModel.attemptCreateStore(body: body, image: myImage ?? Data(), license: licenseImage ?? Data(), licenseISFile: licenseISFile)
            }
        }

    }
}


// MARK: Binding

extension CreateStoreViewController {
    private func bind() {
        bindLoadingIndicator()
        bindPhoneValidator()
        bindNameValidator()
        bindCreateSuccess()
        bindEmailValidation()
        bindDescriptionValidation()
        bindStoreImageValidation()
        bindLicenseImageValidation()
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
    
    private func bindPhoneValidator() {
        viewModel.$showPhoneValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindNameValidator() {
        viewModel.$showNameValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindEmailValidation() {
        viewModel.$showEmailValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindDescriptionValidation() {
        viewModel.$showDescriptionValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindStoreImageValidation() {
        viewModel.$showStoreImageValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindLicenseImageValidation() {
        viewModel.$showLicenseImageValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindCreateSuccess() {
        viewModel.successCreateStoreState.sink { [weak self] in
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
