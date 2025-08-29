//
//  AddAddressViewController.swift
//  Najat
//
//  Created by rania refaat on 22/07/2024.
//

import UIKit

class AddAddressViewController: BaseController {

    @IBOutlet private weak var locationTF: AppFontTextField!
    @IBOutlet private weak var areaTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var streetTextField: UITextField!
    @IBOutlet private weak var homeTextField: UITextField!
    @IBOutlet private weak var flatNoTextField: UITextField!

    private lazy var viewModel: AddAddressViewModelProtocol = {
        AddAddressViewModel(coordinator: coordinator)
    }()
    
    var lat: Double?
    var lng: Double?
    
    private let governoratesDataPicker = DataPicker()
    private var governorateID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        binding()
    }

    @IBAction private func locationButtonTapped(_ sender: UIButton) {
        push(AddAddressLocationViewController(delegate: self))
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        if streetTextField.text.isNilOrEmpty {
            showAlert(with: "Enter your street number", title: .error)
        }else{
            if homeTextField.text.isNilOrEmpty {
                showAlert(with: "Enter your house number", title: .error)
            }else{
                if flatNoTextField.text.isNilOrEmpty {
                    showAlert(with: "Enter your apartment number", title: .error)
                }else{
                    addressRequest(body: addAddressBody())
                }
            }
        }
    }
}

extension AddAddressViewController {
    
    func setupView() {
        setTitle(AppStrings.addAddress.message)
        setupGovernoratesDataPicker()
    }
    
    func addAddressBody() -> AddressBody {
        let addBody = AddressBody(
            name: nameTextField.text.unwrapped(or: ""),
            address: locationTF.text.unwrapped(or: ""),
            lat: lat.unwrapped(or: 0.0),
            lng: lng.unwrapped(or: 0.0),
            areaId: governorateID ?? 0,
            streetNo: (streetTextField.text?.int).unwrapped(or: 0),
            homeNo: (homeTextField.text?.int).unwrapped(or: 0),
            flatNo: (flatNoTextField.text?.int).unwrapped(or: 0)
        )
      return addBody
    }

    func setupGovernoratesDataPicker() {
        
        governoratesDataPicker.initPickerView(arrayString: viewModel.governoratesTitle(),txtField: areaTextField, view: view) { [weak self] index in
            guard let self = self else {return}
            guard let index = index else {return}
            self.governorateID = viewModel.governoratesItem(for: index).id.unwrapped(or: -1)
        }
    }
    
}
extension AddAddressViewController {
    func binding() {
        bindLoading()
        bindFitchData()
        bindReloadViews()
        governoratesRequest()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            guard let self else {return}
            $0 ? self.startLoading() : self.stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindFitchData() {
        viewModel.uiModel.$fetchData.sink { [weak self] in
            guard let self else {return}
            if $0 {
                setupGovernoratesDataPicker()
            }
        }.store(in: &cancellable)
    }

    func bindReloadViews() {
        viewModel.uiModel.$reloadViews.sink { [weak self] status in
            guard let self, status else { return }
//            popToSpecific(vc: AddAddressViewController())
            popMe()
        }.store(in: &cancellable)
    }

    func addressRequest(body: AddressBody) {
        Task {
            await viewModel.addAddress(body: body)
        }
    }

    func governoratesRequest() {
        Task {
            await viewModel.getGovernorates()
        }
    }
}
extension AddAddressViewController: PassLocation{
    func passAddress(_ address: AddressViewModel) {
        print(address)
        locationTF.text = address.address
        lat = address.lat
        lng = address.lng
    }
    
}
