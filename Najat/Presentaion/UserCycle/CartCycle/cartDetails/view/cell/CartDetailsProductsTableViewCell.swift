//
//  CartDetailsProductsTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class CartDetailsProductsTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerImageView: UIView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productCountLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var favouritImageView: UIImageView!
    @IBOutlet private weak var favouritLabel: AppFontLabel!
    
    let deleteView: UIView = {
            let view = UIView()
            view.backgroundColor = .red
            view.layer.cornerRadius = 12 // Adjust to match the desired radius
            view.layer.masksToBounds = true

            // Add delete icon and label
            let iconImageView = UIImageView(image: UIImage(systemName: "trash"))
            iconImageView.tintColor = .white
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(iconImageView)

            let label = UILabel()
            label.text = "حذف"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)

            // Set up constraints
            NSLayoutConstraint.activate([
                iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),

                label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])

            return view
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupViews()
        }

        private func setupViews() {
            contentView.addSubview(deleteView)
            deleteView.translatesAutoresizingMaskIntoConstraints = false
            deleteView.isHidden = true // Initially hidden

            // Position the delete view behind the cell content
            NSLayoutConstraint.activate([
                deleteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                deleteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                deleteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                deleteView.widthAnchor.constraint(equalToConstant: 100) // Adjust width as needed
            ])
        }

        // Method to show delete view
        func showDeleteView() {
            deleteView.isHidden = false
            contentView.backgroundColor = .clear
        }

        // Method to hide delete view
        func hideDeleteView() {
            deleteView.isHidden = true
            contentView.backgroundColor = .white
        }
    private var productCount: Int {
        productCountLabel.text?.int ?? 1
    }
    
    private var productData: ItemEntity?
    
    var addItems: (() -> Void)?
    var removeItems: (() -> Void)?
    var likeItem: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerImageView.setRadius(radius: 7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func didTapDelete(_ sender: Any) {
        removeItems?()
    }
    
    @IBAction private func didTapSave(_ sender: Any) {
        likeItem?()
    }
    
    @IBAction private func didTapMinus(_ sender: Any) {
//        guard (productCount > 1) else { return }
        productCountLabel.text = (productCount - 1).string
        addItems?()
    }
    
    @IBAction private func didTapPlus(_ sender: Any) {
        guard (productCount < productData?.product?.availableQty ?? 1) else { return }

        productCountLabel.text = (productCount + 1).string
        addItems?()
    }
}

extension CartDetailsProductsTableViewCell {
    func getQnt() -> Int {
        productCount
    }
    
    func configCell(for model: ItemEntity) {
        self.productData = model
        productImage.load(with: model.product?.image)
        productNameLabel.text = model.product?.name
//        productPriceLabel.text = model.total?.string.addCurrency
        productPriceLabel.text = model.price?.addCurrency
        productCountLabel.text = model.qty?.string
        
        setupLikeImage(model.product?.isFavourite)
    }

    func setupLikeImage(_ status: Bool?) {
        let image = (status ?? false) ? (UIImage(named: "love")) : (UIImage(named: "cartUnLike"))
        let text = (status ?? false) ? AppStrings.removeFromFavorites.message : AppStrings.AddToFavorites.message
     
        favouritImageView.image = image
        favouritLabel.text = text
    }
}
