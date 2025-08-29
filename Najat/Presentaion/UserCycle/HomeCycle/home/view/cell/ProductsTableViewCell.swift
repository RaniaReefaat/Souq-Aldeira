//
//  ProductsTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 25/06/2024.
//

import UIKit
import AVFoundation
import AVKit

class ProductsTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bestSellerView: UIView!

    
    // Variables
    var addToCartButtonTapped : (()->Void)?
    var loveButtonTapped : (()->Void)?
    var shareButtonTapped : (()->Void)?
    var showStoreButtonTapped : (()->Void)?

    private var playIndex = 0
    private var mediaArray = [Media]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        [collectionView].forEach({$0?.delegate = self})
        [collectionView].forEach({$0?.dataSource = self})
        collectionView.register(cellType: ProductSliderCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        [collectionView].forEach({$0?.showsVerticalScrollIndicator = false})
        [collectionView].forEach({$0?.showsHorizontalScrollIndicator = false})
        pageControl.currentPage = 0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        addToCartButtonTapped?()
    }
    @IBAction func loveButtonTapped(_ sender: UIButton) {
        loveButtonTapped?()
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareButtonTapped?()
    }
    @IBAction func playVideoButtonTapped(_ sender: UIButton) {
    }
    @IBAction func showStoreButtonTapped(_ sender: UIButton) {
        showStoreButtonTapped?()
    }
    func configCell(data: Products){
        let isFavorite = data.isFavourite ?? false
        if isFavorite{
            loveButton.setImage(UIImage(named: "love"), for: .normal)
        }else{
            loveButton.setImage(UIImage(named: "love1"), for: .normal)
        }
        
        // store
        storeNameLabel.text = data.store?.name
        storeImageView.load(with: data.store?.image)
        
        // product
        productNameLabel.text = data.name
        detailsLabel.text = data.description
        timeLabel.text = data.createdAt
        
        let price = data.price
        
        if price != nil {
            priceView.isHidden = false
            addToCartButton.isHidden = false
            priceLabel.text = price!.addCurrency
        }else{
            priceView.isHidden = true
            addToCartButton.isHidden = true
        }
        
        self.mediaArray = data.media ?? []
        collectionView.reloadData()
        pageControl.numberOfPages = mediaArray.count
        
        let isBestSeller = data.isBestSeller ?? true
        if isBestSeller{
            bestSellerView.isHidden = false
        }else{
            bestSellerView.isHidden = true
        }
        let lang = L102Language.getCurrentLanguage()
        if lang == "ar" {
            bestSellerView.clipsToBounds = true
            bestSellerView.layer.cornerRadius = 10
            bestSellerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] // Top right corner, Top left corner respectively

        }else{
//            bestSellerView.rightCornerRadius = 0
//            bestSellerView.leftCornerRadius = 10
            bestSellerView.clipsToBounds = true
            bestSellerView.layer.cornerRadius = 10
            bestSellerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Top right corner, Top left corner respectively

        }
    }
}
extension ProductsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ProductSliderCollectionViewCell.self, for: indexPath)
        
        cell.configCell(media: mediaArray[indexPath.row])
        cell.muteButton.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
            //            cell.isMute.toggle()
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width)  , height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll ended")
        handleScrollEnd()
    }
//    
    // Called when the user lifts their finger from dragging the scroll view
//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            if !decelerate {
//                if scrollView == collectionView {
//                    // If the scroll view does not decelerate, handle scroll end directly
//                    handleScrollEnd()
//    
//                }
//            }
//        }
//    
//    // Function to handle the end of scrolling
    private func handleScrollEnd() {
        
        print(playIndex)
        let indexPath = IndexPath(item: playIndex, section: 0)
//        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
//            cell.pauseVideo()
//        }
        guard let collectionView = self.collectionView else { return }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Get the center of the collection view
        let centerPoint = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        
        // Find the closest visible cell to the center
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            print("Center index path: \(centerIndexPath)")
            playIndex = centerIndexPath.row
        }
        
        print(playIndex)
        
//        if !(mediaArray[playIndex].isImage ?? false) {
//            let newIndexPath = IndexPath(item: playIndex, section: 0)
//            if let cell = collectionView.cellForItem(at: newIndexPath) as? ProductSliderCollectionViewCell {
//                cell.playVideo(media: mediaArray[newIndexPath.row])
//            }
//        }
        pageControl.currentPage = playIndex
        
    }
//    
//    private func playFirstCellVideo() {
//        for cell in collectionView.visibleCells {
//            if let videoCell = cell as? ProductSliderCollectionViewCell {
//                videoCell.pauseVideo() // Stop video playback in each visible cell
//            }
//        }
//        let indexPath = IndexPath(item: 0, section: 0)
//        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
//            cell.playVideo(media: mediaArray[indexPath.row])
//        } else {
//            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if let cell = self.collectionView.cellForItem(at: indexPath) as? ProductSliderCollectionViewCell {
//                    cell.playVideo(media: self.mediaArray[indexPath.row])
//                }
//            }
//        }
//    }
}
