//
//  AddFavoriteFolderViewController.swift
//  Najat
//
//  Created by rania refaat on 14/11/2024.
//

import UIKit

class AddFavoriteFolderViewController: BaseController {

    @IBOutlet weak var nameTF: UITextField!

    private lazy var viewModel: AddFavoriteFolderViewModel = {
        AddFavoriteFolderViewModel(coordinator: coordinator)
    }()
    
    private var delegate: UpdateFavoriteFolderList
    
    init(delegate: UpdateFavoriteFolderList) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    @IBAction func addFolderButtonTapped(_ sender: AppFontButton) {
        let name = nameTF.text
        if !name.isNilOrEmpty {
            Task {
                await viewModel.addFavoriteFile(name: name!)
            }
        }else{
            showAlert(with: "enter name".localized, title: .error)
        }
    }
    @IBAction func dismissButtonTapped(_ sender: AppFontButton) {
        dismissMe()
    }
}
// MARK: Binding
extension AddFavoriteFolderViewController {
    private func bind() {
        bindLoadingIndicator()
        bindAddSuccess()
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindAddSuccess() {
        viewModel.$addSuccess.sink { [weak self] status in
            guard let self, status else { return }
            self.delegate.updateFavoriteFolderList()
            self.dismiss()
        }.store(in: &cancellable)
    }
}
protocol UpdateFavoriteFolderList {
    func updateFavoriteFolderList()
}
