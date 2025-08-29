//
//  UIVideoPickerViewController.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit
import AVFoundation


public protocol VideoPickerDelegate: AnyObject {
    func didSelect(image: URL?, message: String?)
}

open class VideoPicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: VideoPickerDelegate?
    private var messageText: String?
    
    public init(presentationController: UIViewController, delegate: VideoPickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.movie"]
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
    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .black
        if let action = self.action(for: .camera, title: "Record Video".localized) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Select Video".localized) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
        
    }
    private func pickerController(_ controller: UIImagePickerController, didSelect image: Any?) {
        self.delegate?.didSelect(image: image as? URL, message: messageText)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension VideoPicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            messageText = nil
            self.pickerController(picker, didSelect: image)
        }
        else if let image = info[.originalImage] as? UIImage {
            messageText = nil
            self.pickerController(picker, didSelect: image)
        }
        else if let image = info[.mediaURL] as? URL {
            let asset = AVAsset(url: image)

            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)

            print("the duration is",durationTime)

            print(durationTime)

            if durationTime < 30 {
//                self.pickerController(picker, didSelect: nil)
                messageText = nil
                self.pickerController(picker, didSelect: image)

            }else{
                DispatchQueue.main.async {
                    self.messageText = "please select video less than 30 seconds".localized
                    self.pickerController(picker, didSelect: nil)
                }
            }

        }
        
        
    }
}

extension VideoPicker: UINavigationControllerDelegate {
    
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

