//
//  VerifyProfilePhoneViewModel.swift
//  Najat
//
//  Created by Rania Refat on 29/06/2025.
//

import Combine
import Foundation

class VerifyProfilePhoneViewModel {
    
    @Published var loadingIndicator: ScreenState<Void> = .ideal
    
    var codeResendState: PassthroughSubject<Void, Never> = .init()
    var verificationState: PassthroughSubject<Void, Never> = .init()
    
    private let coordinator: CoordinatorProtocol
    private var profileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
}

extension VerifyProfilePhoneViewModel {
    
    @MainActor
    func attemptVerify(body: VerifyPhoneBody) async {
        loadingIndicator = .loading
        
        let verify = await profileUseCase.verifyProfilPhone(phone: body.phone ?? "", code: body.code)
        
        switch verify {
        case .success(let user):
            loadingIndicator = .success(())
            UserDefaults.userData?.phone = body.phone ?? ""
            print(UserDefaults.userData?.phone)
            verificationState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func attemptResendCode(phone: String) async {
        loadingIndicator = .loading
        
        let resendCode = await profileUseCase.updateProfilPhone(phone: phone)
        
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
