//
// SelfSizedUITableView.swift
// Core
//
// Created by Youssef on 15/02/2021.
// Copyright © 2021 Orcas. All rights reserved.
//

import UIKit

class SelfSizedUITableView: UITableView {
    weak var heightDelegate: UIScrollViewHeighDelegate? = nil
    override var contentSize: CGSize {
        didSet {
            heightDelegate?.UIScrollView(self, didUIScrollViewHeightChanged: contentSize.height * zoomScale)
        }
    }
}

class SelfSizedUICollectionView: UICollectionView {
    weak var heightDelegate: UIScrollViewHeighDelegate? = nil
    override var contentSize: CGSize {
        didSet {
            heightDelegate?.UIScrollView(self, didUIScrollViewHeightChanged: contentSize.height * zoomScale)
        }
    }
}

protocol UIScrollViewHeighDelegate: AnyObject {
    func UIScrollView(_ uiScrollView: UIScrollView, didUIScrollViewHeightChanged height: CGFloat)
}
