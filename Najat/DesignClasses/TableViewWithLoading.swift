//
//  File.swift
//  Dukan
//
//  Created by Mohammed Balegh on 03/05/2023.
//

import UIKit

final class TableViewWithLoading: UITableView, UITableViewDelegate {
    
    var isLoading: Bool = false
    var onRefresh: (() -> Void)?
    var pageNumber: Int = 1
    var onGetNewPage: (() -> Void)?
    var height: CGFloat = 97
    var selectRow: ((_ indexPath: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add refresh control to table view
        let refreshControl = UIRefreshControl()
        self.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        // Set table view delegate to self
        self.delegate = self
    }
    
    func fetchData() {
        // If already loading data, return
        if isLoading {
            return
        }
        // Set isLoading to true
        isLoading = true
        // Show loading indicator in refresh control
        let refreshControl = subviews.first(where: { $0 is UIRefreshControl }) as? UIRefreshControl
        refreshControl?.beginRefreshing()
        // Set isLoading to false
        isLoading = false
        // Hide loading indicator in refresh control
        refreshControl?.endRefreshing()
    }
    
    @objc func refreshData(_ sender: Any) {
        onRefresh?()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight && !isLoading {
            onGetNewPage?()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectRow?(indexPath.row)
    }
}

class CollectionViewWithLoading: UICollectionView, UICollectionViewDelegate {
    
    var isLoading: Bool = false
    var onRefresh: (() -> Void)?
    var pageNumber: Int = 1
    var onGetNewPage: (() -> Void)?
    var height: CGFloat = 97
    var selectRow: ((_ indexPath: IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add refresh control to table view
        let refreshControl = UIRefreshControl()
        self.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        // Set table view delegate to self
        self.delegate = self
    }
    
    func fetchData() {
        // If already loading data, return
        if isLoading {
            return
        }
        // Set isLoading to true
        isLoading = true
        // Show loading indicator in refresh control
        let refreshControl = subviews.first(where: { $0 is UIRefreshControl }) as? UIRefreshControl
        refreshControl?.beginRefreshing()
        // Set isLoading to false
        isLoading = false
        // Hide loading indicator in refresh control
        refreshControl?.endRefreshing()
    }
    
    @objc func refreshData(_ sender: Any) {
        onRefresh?()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight && !isLoading {
            onGetNewPage?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRow?(indexPath)
    }
}
