//
//  VerifyAccountViewModel.swift
//  Najat
//
//  Created by rania refaat on 09/06/2024.
//

import Combine
import Foundation

class VerifyAccountViewModel {
    
    @Published var loadingIndicator: ScreenState<Void> = .ideal
    
    var codeResendState: PassthroughSubject<Void, Never> = .init()
    var verificationState: PassthroughSubject<Void, Never> = .init()
    
    private let coordinator: CoordinatorProtocol
    private var verifyUseCase: VerifyUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        verifyUseCase: VerifyUseCaseProtocol = VerifyUseCase()
    ){
        self.coordinator = coordinator
        self.verifyUseCase = verifyUseCase
    }
}

extension VerifyAccountViewModel {
    
    @MainActor
    func attemptVerify(body: VerifyPhoneBody) async {
        loadingIndicator = .loading
        
        let verify = await verifyUseCase.verify(body: body)
        
        switch verify {
        case .success(let user):
            loadingIndicator = .success(())
            UserDefaults.userData = user
            verificationState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func attemptResendCode(phone: String) async {
        loadingIndicator = .loading
        
        let resendCode = await verifyUseCase.resendVerificationCode(with: phone)
        
        switch resendCode {
        case .success:
            loadingIndicator = .success(())
            codeResendState.send(())
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
}
