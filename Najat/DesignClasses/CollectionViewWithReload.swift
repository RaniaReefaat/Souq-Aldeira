//
//  CollectionViewWithReload.swift
//  zoz-resturant
//
//  Created by mohammed balegh on 01/03/2023.
//

import UIKit
 
public protocol CollectionViewWithReloadDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
}

extension CollectionViewWithReloadDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { CGSize(width: 0, height: 0) }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {  UICollectionReusableView() }
}

enum CategoryCellType {
    case withImage
    case withoutImage
}

class CollectionViewWithReload: UICollectionView, UICollectionViewDelegate {

    open weak var reloadDelegate: CollectionViewWithReloadDelegate?
    
    let myRefreshControl = UIRefreshControl()
    var refreshClosure: (() -> Void)?
    var loadMoreClosure: (() -> Void)?
    var categoryTpe: ((CategoryCellType) -> Void)?
    var isLoadingMore = false
    var currentPage = 1

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupLoadMoreIndicator()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        myRefreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.addSubview(myRefreshControl)
    }

    private func setupLoadMoreIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        footerView.addSubview(indicatorView)
        indicatorView.center = footerView.center
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.footerReferenceSize = footerView.frame.size
        }
        self.backgroundView = footerView
    }

    @objc private func handleRefresh() {
        refreshClosure?()
        myRefreshControl.endRefreshing()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > 60 {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                categoryTpe?(.withoutImage)
//                layout.sectionInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
                layout.sectionHeadersPinToVisibleBounds = true
            }
        } else {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                categoryTpe?(.withImage)
                layout.sectionHeadersPinToVisibleBounds = false
            }
        }

        if offsetY + 50 > contentHeight - frameHeight && !isLoadingMore {
            isLoadingMore = true
            loadMoreClosure?()
        }
    }

    func stopLoadingMore() {
        isLoadingMore = false
    }

    func reset() {
        setContentOffset(.zero, animated: false)
        currentPage = 1
        stopLoadingMore()
        reloadData()
    }
    
    func register(string: String) {
        register(UINib(nibName: string, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: string)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reloadDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}


extension CollectionViewWithReload: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        reloadDelegate?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        reloadDelegate?.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        reloadDelegate?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 48
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        reloadDelegate?.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        reloadDelegate?.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) ?? UICollectionReusableView()
    }
}

protocol HorizontalReloadDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class HorizontalReloadCollectionView: UICollectionView, UICollectionViewDelegate {
    
    weak var horizontalDelegate: HorizontalReloadDelegate?
    
    let myRefreshControl = UIRefreshControl()
    var refreshClosure: (() -> Void)?
    var loadMoreClosure: (() -> Void)?
    var isLoadingMore = false
    var currentPage = 1

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupLoadMoreIndicator()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        myRefreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.addSubview(myRefreshControl)
    }

    private func setupLoadMoreIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        footerView.addSubview(indicatorView)
        indicatorView.center = footerView.center
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.footerReferenceSize = footerView.frame.size
        }
        self.backgroundView = footerView
    }

    @objc private func handleRefresh() {
        refreshClosure?()
        myRefreshControl.endRefreshing()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.x
        let contentHeight = scrollView.contentSize.width
        let frameHeight = scrollView.frame.size.width

        if offsetY + 50 > contentHeight - frameHeight && !isLoadingMore {
            isLoadingMore = true
            loadMoreClosure?()
        }
    }

    func stopLoadingMore() {
        isLoadingMore = false
    }

    func reset() {
        setContentOffset(.zero, animated: false)
        currentPage = 1
        stopLoadingMore()
        reloadData()
    }
    
    func register(string: String) {
        register(UINib(nibName: string, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: string)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        horizontalDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
