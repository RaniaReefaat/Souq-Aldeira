//
//  UIImagePickerController+extenion.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit
import AVFoundation


public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.modalPresentationStyle = .overFullScreen
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    public func present(from sourceView: UIView, type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async(execute: {
            self.pickerController.sourceType = type
            if type == .camera {
                self.pickerController.cameraDevice = .front
            }
            self.presentationController?.modalPresentationStyle = .overFullScreen
            self.presentationController?.present(self.pickerController, animated: true)
        })

//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.view.tintColor = .black
//        if let action = self.action(for: .camera, title: "Take photo".localized) {
//            alertController.addAction(action)
//        }
////        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll".localized) {
////            alertController.addAction(action)
////        }
//        if let action = self.action(for: .photoLibrary, title: "Photo library".localized) {
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = sourceView
//            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//        self.presentationController?.present(alertController, animated: true)
        
    }
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        pickerController.navigationController?.view.backgroundColor = .black
        pickerController.navigationBar.barTintColor = .black
        pickerController.navigationBar.isTranslucent = false
        pickerController.navigationBar.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        pickerController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        ]
    }
   
}

