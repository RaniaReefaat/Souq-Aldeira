//
//  AddressListViewController.swift
//  Najat
//
//  Created by rania refaat on 22/07/2024.
//

import UIKit

protocol MyAddressDelegate: AnyObject {
    func updateShippingAddress(_ address: AddressEntity)
}

class AddressListViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var viewModel: AddressListViewModelProtocol = {
        AddressListViewModel(coordinator: coordinator)
    }()
  
    private weak var delegate: MyAddressDelegate?
    
    init(delegate: MyAddressDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Setup APIs Here For Fetch New Data After Add Addresses
        addressRequest()
    }
    
    @IBAction func addNewAddressButtonTapped(_ sender: AppFontButton) {
        push(AddAddressViewController())
    }
}

private extension AddressListViewController {
    
    func setupView() {
        setupNavigationView()
        setupTableView()
    }
    
    func setupNavigationView() {
        addNotifyButton()
        setTitle(AppStrings.addresses.message)
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: AddressListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

    }
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: AddressListTableViewCell.self, for: indexPath)
        let id = viewModel.cellData(at: indexPath.row).id ?? 0

        cell.configCell(model: viewModel.cellData(at: indexPath.row))

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = viewModel.cellData(at: indexPath.row).id ?? 0

            deleteAddress(id: id)
        }
    }
    private func deleteAddress(id: Int){
        let alert = UIAlertController(title: "Are you sure you want to delete the address?".localized, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                Task {
                    await self.viewModel.deleteAddress(id: id)

                }
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = viewModel.cellData(at: indexPath.row)
        guard delegate.isNil else {
            delegate?.updateShippingAddress(address)
            popMe()
            return
        }
    }
}

extension AddressListViewController {
    func binding() {
        bindLoading()
        bindReloadViews()
        bindShowEmptyView()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            guard let self else {return}
            $0 ? self.startLoading() : self.stopLoading()
        }.store(in: &cancellable)
    }
    
    func bindReloadViews() {
        viewModel.uiModel.$reloadViews.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
    
    func bindShowEmptyView() {
        viewModel.uiModel.$showEmptyView.sink { [weak self] in
            $0 ? self?.showEmptyView(with: .address) : self?.removeEmptyView()
        }.store(in: &cancellable)
    }

    func addressRequest() {
        Task {
            await viewModel.getAddress()
        }
    }
}
