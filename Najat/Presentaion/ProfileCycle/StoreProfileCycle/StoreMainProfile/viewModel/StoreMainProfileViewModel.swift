//
//  StoreMainProfileViewModel.swift
//  Najat
//
//  Created by rania refaat on 31/08/2024.
//

import Combine
import Foundation

class StoreMainProfileViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal

    var setUserDataState: PassthroughSubject<Void, Never> = .init()
    @Published var acceptOrderMessage : String?
    @Published var ordersArray: [OrdersModelData] = []
    @Published var setUserLogoutDataState = false
    @Published var reloadData = false
    
    private var lastPage = 1
    private var currentPage = 0

    
    private let coordinator: CoordinatorProtocol
    private var profileUseCase: StoreProfileUseCaseProtocol
    private var userProfileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: StoreProfileUseCaseProtocol = StoreProfileUseCase(),
        userProfileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()

    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
        self.userProfileUseCase = userProfileUseCase

    }
}
extension StoreMainProfileViewModel {
    private func isLoadData() -> Bool{
        print(currentPage , "lastPage" , lastPage )
        if currentPage != lastPage {
            currentPage = currentPage + 1
            print(currentPage)
            return true
        }else {
            return false
        }
    }
    func viewWillAppear(){
        lastPage = 1
        currentPage = 0
        ordersArray = []
    }
}

extension StoreMainProfileViewModel {
    @MainActor
    func getOrders() async {
        guard !reloadData else{return}
        guard isLoadData() else {return}
        loadingIndicator = .loading
        
        let orders = await profileUseCase.getOrders(currentPage)
        
        switch orders {
        case .success(let data):
            loadingIndicator = .success(())
            lastPage = data.paginate?.totalPages ?? 1
            currentPage = data.paginate?.currentPage ?? 1
            ordersArray.append(contentsOf: data.items ?? [])
            reloadData = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    
    @MainActor
    func getProfileData() async {
//        loadingIndicator = .loading
        
        let userData = await profileUseCase.getProfileData()
        makeMessageEmpty()

        switch userData {
        case .success(let user):
//            loadingIndicator = .success(())
            let token = UserDefaults.userData?.token ?? ""
            var userData = user
            userData.token = token
            UserDefaults.userData = userData
            setUserDataState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func acceptOrder(index: Int) async {
        loadingIndicator = .loading
        let id = ordersArray[index].id ?? 0
        let order = await profileUseCase.acceptOrder(orderID: id)
        
        switch order {
        case .success(let order):
            loadingIndicator = .success(())
            ordersArray[index].status = .accepted
            reloadData = true
            acceptOrderMessage = order.message ?? ""
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        default:
            loadingIndicator = .failure(error.error)
        }
    }
    func makeMessageEmpty(){
        acceptOrderMessage = nil
    }
    @MainActor
    func logout() async {
        loadingIndicator = .loading
        
        let userData = await userProfileUseCase.logout()
        
        switch userData {
        case .success(let user):
            loadingIndicator = .success(())
            UserDefaults.userData = nil
            setUserLogoutDataState = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
}
extension StoreMainProfileViewModel {
    
    var numberOfRows: Int {
        ordersArray.count
    }
    
    func cellData(at index: Int) -> OrdersModelData {
        return ordersArray[index]
    }
}

enum ProfileSelectedType{
    case products
    case orders
}
