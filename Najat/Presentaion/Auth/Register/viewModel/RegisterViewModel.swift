//
//  RegisterViewModel.swift
//  Najat
//
//  Created by rania refaat on 09/06/2024.
//

import Combine
import Foundation

class RegisterViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var showPhoneValidation = ""
    @Published var showNameValidation = ""
    @Published var showTermsValidation = ""
    
    private let coordinator: CoordinatorProtocol
    private var registerUseCase: RegisterUseCaseProtocol
    var verificationState: PassthroughSubject<Void, Never> = .init()

    init(
        coordinator: CoordinatorProtocol,
        registerUseCase: RegisterUseCaseProtocol = RegisterUseCase()
    ) {
        self.coordinator = coordinator
        self.registerUseCase = registerUseCase
    }
}

extension RegisterViewModel {
    
    @MainActor
    func attemptRegister(body: RegisterBody) async {
        loadingIndicator = .loading
        
        let register = await registerUseCase.RegisterUseCase(body: body)
        
        switch register {
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
        case .name:
            showNameValidation = error.error
        case .terms:
            showTermsValidation = error.error

        default:
            loadingIndicator = .failure(error.error)
        }
    }
}
