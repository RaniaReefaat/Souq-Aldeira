//
//  LoginUseCase.swift
//  App
//
//  Created by Mohammed Balegh on 08/11/2023.
//

import Combine

protocol LoginUseCaseProtocol {
    mutating func loginUseCase(body: LoginBody) async -> Result<EmptyData, MyAppError>
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    var loginRepo: LoginRequestRepoProtocol
    
    private var bag = AppBag()
    
    init(loginRepo: LoginRequestRepoProtocol = LoginRepoImplementation()) {
        self.loginRepo = loginRepo
    }
    
    mutating func loginUseCase(body: LoginBody) async -> Result<EmptyData, MyAppError> {
        if case .failure(let error) = body.validateBody {
            return .failure(MyAppError.localValidation(error))
        }
        
        return await loginRepo
            .login(body: body)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
}

actor SharedEventPublisher {
    private var subject = PassthroughSubject<String, Never>()
    private var cancelLabels: Set<AnyCancellable> = []

    func emitEvent(event: String) {
        subject.send(event)
    }

    func subscribe(handler: @escaping (String) -> Void) {
        let cancellable = subject.sink { state in
            handler(state)
        }
        cancelLabels.insert(cancellable)
    }

    func cancelSubscription() {
        cancelLabels.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
