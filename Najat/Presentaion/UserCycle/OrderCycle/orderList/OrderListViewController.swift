//
//  OrderListViewController.swift
//  Najat
//
//  Created by rania refaat on 23/07/2024.
//

import UIKit

class OrderListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        addNotifyButton()
        setupTableView()
        setTitle(AppStrings.orders.message)

    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: OrderListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }

    @IBAction func addNewAddressButtonTapped(_ sender: AppFontButton) {
        push(AddAddressViewController())
    }
}
extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderListTableViewCell.self, for: indexPath)

        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        push(CartDetailsViewController())
    }
}
