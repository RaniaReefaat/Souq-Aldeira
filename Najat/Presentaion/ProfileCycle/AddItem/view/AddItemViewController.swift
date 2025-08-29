//
//  AddItemViewController.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import UIKit
import YPImagePicker

class AddItemViewController: BaseController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTF: AppFontTextField!
    @IBOutlet weak var priceTF: AppFontTextField!
    @IBOutlet weak var categoryTF: AppFontTextField!
    @IBOutlet weak var subCategoryTF: AppFontTextField!
    @IBOutlet weak var descriptionTV: PlaceHolderTextView!
    @IBOutlet weak var itemCountLabel: AppFontLabel!
    @IBOutlet weak var visableSwitch: UISwitch!
    @IBOutlet weak var visableStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addAttachmentsView: UIView!
    
    private lazy var viewModel: AddItemViewModellProtocol = {
        AddItemViewModel(coordinator: coordinator)
    }()
    
    private let categoryPicker = DataPicker()
    private let subCategoryPicker = DataPicker()
    private var itemImage: Data?
    private var productCount: Int = 1
    private var isVisible: Int = 1
    
    private var categoryID: Int?
    private var subCategoryID: Int?
    
    private var attachmentsArray = [AttachmentsMediaData]() {
        didSet {
            DispatchQueue.main.async {
                let count = self.attachmentsArray.count
                if count == 0 {
                    self.addAttachmentsView.isHidden = false
                    self.collectionView.isHidden = true
                }else{
                    self.addAttachmentsView.isHidden = true
                    self.collectionView.isHidden = false
                }
                self.collectionView.reloadData()
            }
            
        }
    }

    var itemDetails: Products?
    init(itemDetails: Products? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.itemDetails = itemDetails
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        setupViews()
        setupCollectionView()
        priceTF.keyboardType = .decimalPad

        // Do any additional setup after loading the view.
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: AttachmentsCollectionViewCell.self)
    }
    
    @IBAction func didTapMedia(_ sender: Any) {
        uploadMedia()
    }
    
    @IBAction private func didTapSave(_ sender: Any) {
        (itemDetails == nil) ? addItem() : editItem()
    }
    
    @IBAction func didTapVisiable(_ sender: UISwitch) {
        isVisible = (sender.isOn) ? 1 : 0
    }
    
    @IBAction private func didTapMinus(_ sender: Any) {
        guard (productCount > 1) else { return }
        productCount -= 1
        itemCountLabel.text = (productCount).string
    }
    
    @IBAction private func didTapPlus(_ sender: Any) {
        productCount += 1
        itemCountLabel.text = (productCount).string
    }
    
}
extension AddItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentsArray.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: AttachmentsCollectionViewCell.self, for: indexPath)
        if indexPath.row == 0 {
            cell.addImageView.isHidden = false
            cell.imageContainerView.isHidden = true
            cell.videoImageView.isHidden = true
        }else{
            cell.addImageView.isHidden = true
            cell.imageContainerView.isHidden = false
            let newIndex = indexPath.row
            print(newIndex , "newIndex")
            if attachmentsArray[newIndex - 1].isImage ?? false {
                cell.videoImageView.isHidden = true
            }else{
                cell.videoImageView.isHidden = false
                
            }
            let isNew = attachmentsArray[newIndex - 1].isNew ?? false
            if isNew {
                cell.cellImageView.image = attachmentsArray[newIndex - 1].image

            }else{
                cell.cellImageView.load(with: attachmentsArray[newIndex - 1].fileName)
            }
            
        }
        
        
        cell.selectedButtonTapped = { [weak self] in
            guard let self = self else{return}
            uploadMedia()
        }
        cell.deletedButtonTapped = { [weak self] in
            guard let self = self else{return}
            let newIndex = indexPath.row
            attachmentsArray.remove(at: newIndex - 1)
            collectionView.reloadData()
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension AddItemViewController {
    
    private func setupViews() {
        itemCountLabel.text = (productCount).string
        setTitle((itemDetails != nil) ? AppStrings.editItem.message : AppStrings.addItem.message)
        setupDescription()
        setupItemDetails()
//        priceTF.keyboardType = .asciiCapableNumberPad

    }
    func addItem() {
//        var intValue = Int()
//        if let doubleValue = Double(priceTF.text ?? "0") {
//            intValue = Int(doubleValue)
//            print(intValue)  // Output: 24
//        } else {
//            print("Invalid number format")
//        }
        let body = addItemBody(
            name: nameTF.text,
            description: descriptionTV.text,
            price: Double(priceTF.text ?? "0") ?? 0,
            categoryId: categoryID,
            subcategoryId: subCategoryID,
            qty: productCount
        )
        print(body)
        addItemRequest(body: body)
    }
    
    func editItem() {
        var intValue = Int()
        if let doubleValue = Double(priceTF.text ?? "0") {
            intValue = Int(doubleValue)
            print(intValue)  // Output: 24
        } else {
            print("Invalid number format")
        }

        let body = EditItemBody(
            name: nameTF.text,
            description: descriptionTV.text,
            price: intValue,
            categoryId: categoryID,
            subcategoryId: subCategoryID,
            qty: productCount,
            is_visible: isVisible
        )
        print(priceTF.text)

        editItemRequest(body: body)
    }
    // setData
    func setupItemDetails() {
        guard let item = itemDetails else {return attachmentsArray = []}
        nameTF.text = item.name
        var intValue = Int()
        if let doubleValue = Double(item.price ?? "0") {
            intValue = Int(doubleValue)
            print(intValue)  // Output: 24
        } else {
            print("Invalid number format")
        }
        if intValue != 0 {
            priceTF.text = intValue.string
        }else{
            priceTF.text = nil
        }
        
        categoryTF.text = item.category?.name
        categoryID = item.category?.id
        subCategoryTF.text = item.subcategory?.name
        getSubCategory(id: categoryID ?? 0)
        subCategoryID = item.subcategory?.id
        descriptionTV.text = item.description
        productCount = item.qty ?? 1
        itemCountLabel.text = item.qty?.string
        isVisible = item.isVisible ?? 0
//        visableSwitch.isOn = (item.isVisible == 1)
        if isVisible == 1 {
            visableSwitch.setOn(true, animated: false)
        } else {
            visableSwitch.setOn(false, animated: false)
        }
        visableStackView.isHidden = false
        createButton.setTitle("Edit Item".localized, for: .normal)
      
        let media = item.media ?? []
        for item in media {
            let isImage = item.isImage
            attachmentsArray.append(AttachmentsMediaData(data: nil, image: nil, isImage: isImage, isNew: false, fileName: item.file))
        }
        if !attachmentsArray.isEmpty {
            if attachmentsArray.count <= 1 {
                itemImageView.load(with: attachmentsArray[0].fileName)
            }
        }
    }
    private func uploadMedia() {
        var config = YPImagePickerConfiguration()
        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 10
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.screens = [.library, .video, .photo]
        config.library.mediaType = .photoAndVideo
        config.library.preSelectItemOnMultipleSelection = false
        config.library.onlySquare = true
        config.library.isSquareByDefault = true
        config.showsCrop = .rectangle(ratio: 1.0) // Set the desired aspect ratio (e.g., 1.0 for square)

        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                    self.attachmentsArray.append(AttachmentsMediaData(data: photo.image.toData(), image: photo.image , isImage: true, isNew: true, fileName: nil))
                    
                case .video(let video):
                    print(video)
                    let videoURL = video.url
                    
                    do {
                        let videoData = try Data(contentsOf: videoURL)
                        // Use videoData as needed
                        print("Video data size: \(videoData.count) bytes")
                        self.getThumbnailFromVideo(url: videoURL) { thumbnailImage in
                            if let image = thumbnailImage {
                                // Use the thumbnail image (e.g., set it to an UIImageView)
                                self.attachmentsArray.append(AttachmentsMediaData(data: videoData, image: image , isImage: false, isNew: true, fileName: nil))

                            } else {
                                print("Failed to generate thumbnail")
                            }
                        }
                    } catch {
                        print("Error converting video to data: \(error)")
                    }
                    
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    private func setupCategoriesPickers() {
        let list = viewModel.categoryTitle()
        categoryPicker.initPickerView(arrayString: list, txtField: categoryTF, view: view) { [weak self] index in
            guard let self = self else {return}
            guard let index = index else {return}
            self.categoryID = self.viewModel.categoryID(index: index)
            self.getSubCategory(id: self.categoryID.unwrapped(or: 0))
        }
    }
    private func setupsubCategoriesPickers() {
        let list = viewModel.subCategoryTitle()
        subCategoryPicker.initPickerView(arrayString: list, txtField: subCategoryTF, view: view) { [weak self] index in
            guard let self = self else {return}
            guard let index = index else {return}
            self.subCategoryID = self.viewModel.subCategoryID(index: index)
        }
    }
    
    private func setupDescription() {
        
        descriptionTV.placeholder = NSString(string: "Enter item description".localized)
        
    }
}

extension AddItemViewController {
    private func binding() {
        bindLoading()
        bindFetchData()
        bindEditSuccess()
        getCategories()
    }
    
    func bindLoading() {
        viewModel.uiModel.$isLoading.sink { [weak self] in
            $0 ? self?.startLoading() : self?.stopLoading()
        }.store(in: &cancellable)
    }
    func bindEditSuccess() {
        viewModel.uiModel.$addSuccess.sink { [weak self] data in
            guard let self, data else { return }
            self.popToRoot()
        }.store(in: &cancellable)
    }
    func bindFetchData() {
        viewModel.uiModel.$fetchData.sink { [weak self] data in
            guard let self else { return }
            self.setupCategoriesPickers()
            self.setupsubCategoriesPickers()
        }.store(in: &cancellable)
    }
    
    private func getCategories() {
        Task {
            await viewModel.getCategory()
        }
    }
    
    private func getSubCategory(id: Int) {
        subCategoryTF.text = nil
        subCategoryID = nil
        Task {
            await viewModel.getSubCategory(id)
        }
    }
    
    private func addItemRequest(body: addItemBody) {
        Task {
            var itemUploadedData: [AttachmentsMediaData] = []
            for item in self.attachmentsArray{
                if item.isNew ?? false {
                    itemUploadedData.append(item)
                }
            }
            await viewModel.AddItem(body: body, image: itemUploadedData)
        }
    }
    private func editItemRequest(body: EditItemBody) {
        let id = itemDetails?.id ?? 0
        Task {
            var itemUploadedData: [AttachmentsMediaData] = []
            for item in self.attachmentsArray{
                if item.isNew ?? false {
                    itemUploadedData.append(item)
                }
            }
            await viewModel.editItem(id: id, body: body, image: itemUploadedData)
        }
    }
}
struct AttachmentsMediaData{
    var data: Data?
    var image: UIImage?
    var isImage: Bool?
    var isNew: Bool?
    var fileName: String?

}
