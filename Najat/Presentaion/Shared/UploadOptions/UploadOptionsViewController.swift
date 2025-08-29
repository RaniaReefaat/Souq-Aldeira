//
//  UploadOptionsViewController.swift
//  WeHire
//
//  Created by rania refaat on 26/02/2024.
//

import UIKit

class UploadOptionsViewController: UIViewController {

    private var delegate: UploadOptionsSelected
    
    init(delegate: UploadOptionsSelected) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func filesButtonTapped(_ sender: UIButton) {
        delegate.passUploadOptions(option: .file)
        dismissMe()
    }
    @IBAction func imagesButtonTapped(_ sender: UIButton) {
        delegate.passUploadOptions(option: .image)
        dismissMe()
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismissMe()
    }
    
}
protocol UploadOptionsSelected{
    func passUploadOptions(option: UploadOptions)
}
enum UploadOptions{
    case file
    case image
}
