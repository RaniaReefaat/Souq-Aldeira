//
//  QuestionsViewController.swift
//  Edrak
//
//  Created by rania refaat on 25/08/2023.
//

import UIKit

class QuestionsViewController: BaseController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: QuestionsViewModel = {
        QuestionsViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setTitle(AppStrings.question.message)
        bind()

    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: QuestionsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

    }

}
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOFRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: QuestionsTableViewCell.self, for: indexPath)
        cell.configCell(data: viewModel.configCell(index: indexPath.row))
        cell.contentView.layoutIfNeeded() // Forces the layout to update
        return cell
    }
}
// MARK: Binding
extension QuestionsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindReloadData()
        getQuestionsData()
    }
    func getQuestionsData() {
        Task {
            await viewModel.getQuestions()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }

    private func bindReloadData() {
        viewModel.$reloadData.sink { [weak self] status in
            guard let self, status else { return }
            tableView.reloadData()
        }.store(in: &cancellable)
    }
}
