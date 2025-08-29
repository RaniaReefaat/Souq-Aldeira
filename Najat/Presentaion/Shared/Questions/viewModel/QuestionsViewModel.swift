//
//  QuestionsViewModel.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import Combine
import Foundation

class QuestionsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var questionsArray: [QuestionsModelData]?
    @Published var reloadData = false

    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
    }
}

extension QuestionsViewModel {
    @MainActor
    func getQuestions() async {
        loadingIndicator = .loading
        
        let questions = await generalUseCase.getQuestions()
        
        switch questions {
        case .success(let data):
            loadingIndicator = .success(())
            questionsArray = data
            reloadData = true
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
extension QuestionsViewModel {
    func numberOFRows()->Int{
        return questionsArray?.count ?? 0
    }
    
    func configCell(index: Int) -> QuestionsModelData{
        return questionsArray?[index] ?? .init(question: nil, answer: nil)
    }
}
