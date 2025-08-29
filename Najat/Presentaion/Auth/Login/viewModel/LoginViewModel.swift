//
//  LoginViewModel.swift
//  Najat
//
//  Created by rania refaat on 06/06/2024.
//

import Combine
import Foundation

class LoginViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var showPhoneValidation = ""

    private let coordinator: CoordinatorProtocol
    private var loginUseCase: LoginUseCaseProtocol
    var verificationState: PassthroughSubject<Void, Never> = .init()

    init(
        coordinator: CoordinatorProtocol,
        loginUseCase: LoginUseCaseProtocol = LoginUseCase()
    ) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
}

extension LoginViewModel {
    
    @MainActor
    func attemptLogin(body: LoginBody) async {
        loadingIndicator = .loading
        
        let login = await loginUseCase.loginUseCase(body: body)
        
        switch login {
        case .success(let user):
            loadingIndicator = .success(())
            verificationState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        case .phone:
            showPhoneValidation = error.error
        default:
            loadingIndicator = .failure(error.error)
        }
    }
}
