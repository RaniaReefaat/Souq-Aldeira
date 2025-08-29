//
//  StoreDetailsViewController.swift
//  Najat
//
//  Created by rania refaat on 19/07/2024.
//

import UIKit

class StoreDetailsViewController: BaseController {
    
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var storeBioLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    private lazy var viewModel: StoreDetailsViewModel = {
        StoreDetailsViewModel(coordinator: coordinator)
    }()
    private var storeID: Int
    private var productsArray = [StoreProduct]()
    private var whatsAppNumber = String()
    private var email = String()

    init(storeID: Int) {
        self.storeID = storeID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bind()

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        collectionView.layer.removeAllAnimations()
        
        collectionHeight.constant = collectionView.contentSize.height
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.updateViewConstraints()
            self?.loadViewIfNeeded()
        }
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: StoreDetailsImagesCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    @IBAction func whatsAppButtonTapped(_ sender: UIButton) {
        openWhatsApp(withPhoneNumber: whatsAppNumber, messageText: nil)
    }
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "mailto:\(email)") {
            openURL(url: url)
        }
    }
    
    @IBAction func unFollowButtonTapped(_ sender: UIButton) {
        Task {
            await viewModel.addAndRemoveFromFollowing(storeID:storeID)
        }
        followButton.isHidden = false
        unFollowButton.isHidden = true

    }
    @IBAction func followButtonTapped(_ sender: UIButton) {
        Task {
            await viewModel.addAndRemoveFromFollowing(storeID:storeID)
        }
        followButton.isHidden = true
        unFollowButton.isHidden = false
    }
}
extension StoreDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: StoreDetailsImagesCollectionViewCell.self, for: indexPath)
        cell.productImageView.load(with: productsArray[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(ProductDetailsViewController(productID: productsArray[indexPath.row].id ?? 0, delegate: nil))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = collectionView.frame.width / 3 - 10
        //        return CGSize(width: width , height: width)
        let numberOfItemsPerRow: CGFloat = 3
        let itemSpacing: CGFloat = 7 // Space between items
        let totalSpacing: CGFloat = (numberOfItemsPerRow - 1) * itemSpacing
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        let height: CGFloat = 100 // Set height for the cells
        
        return CGSize(width: width, height: width)
    }
}
// MARK: Binding
extension StoreDetailsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindStoreData()
        getStoreData()
    }
    func getStoreData() {
        Task {
            await viewModel.getStoreDetails(storeID:storeID)
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }

    private func bindStoreData() {
        viewModel.$reloadStore.sink { [weak self] status in
            guard let self, status else { return }
            setStoreData(data: viewModel.storeData)
        }.store(in: &cancellable)
    }
    private func setStoreData(data: Store?){
        guard let data = data else{return}
        
        // store
        storeNameLabel.text = data.name
        storeImageView.load(with: data.image)
        storeBioLabel.text = data.bio
        
        setTitle(data.name ?? "")
        self.productsArray = data.products ?? []
        collectionView.reloadData()
        
        whatsAppNumber = data.whatsapp ?? ""
        email = data.email ?? ""
        
        let is_following = data.is_followed ?? false
        if is_following {
            followButton.isHidden = true
            unFollowButton.isHidden = false
        }else{
            followButton.isHidden = false
            unFollowButton.isHidden = true

        }
    }
}
