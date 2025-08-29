//
//  CategoryViewController.swift
//  Najat
//
//  Created by rania refaat on 24/06/2024.
//

import UIKit

class CategoryViewController: BaseController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private lazy var viewModel: CategoryViewModel = {
        CategoryViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addNotifyButton()
        setTitle(AppStrings.allCategories.message)
        bind()
    }
    private func setupCollectionView() {
        [categoryCollectionView].forEach({$0?.delegate = self})
        [categoryCollectionView].forEach({$0?.dataSource = self})
        categoryCollectionView.register(cellType: HomeCategoryCollectionViewCell.self)
        [categoryCollectionView].forEach({$0?.showsVerticalScrollIndicator = false})
        [categoryCollectionView].forEach({$0?.showsHorizontalScrollIndicator = false})
        
    }
}
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategory
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HomeCategoryCollectionViewCell.self, for: indexPath)
        cell.allCategoryView.isHidden = true
        cell.categoryView.isHidden = false
        cell.configCell(category: viewModel.configCategory(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.configCategory(at: indexPath.row)
        push(SubCategoryViewController(categoryID: category.id ?? 0, categoryName: category.name ?? ""))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75 , height: 110)
    }
}
extension CategoryViewController {
    private func bind() {
        getCategory()
        bindLoadingIndicator()
        bindCategoryData()
    }
    private func getCategory() {
        Task {
            await viewModel.getCategory()
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindCategoryData() {
        viewModel.$reloadCategory.sink { [weak self] status in
            guard let self, status else { return }
            categoryCollectionView.reloadData()
            
        }.store(in: &cancellable)
    }
    
}
