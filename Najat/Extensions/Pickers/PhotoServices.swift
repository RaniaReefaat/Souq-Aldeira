//
//  PhotoServices.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit
// import AVFoundation

class PhotoServices: NSObject {
    
    static let shared = PhotoServices()
    
    var completion: ((_ file: Any, _ name: String) -> Void)?
    private let imagePicker = UIImagePickerController()
    
    override init() {
        super.init()
        // imagePicker.allowsEditing = true
        // imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func pickImageFromGallery(on: UIViewController, completion: @escaping (_ image: Any, _ name: String)->(), _ sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String] // to set image only
        
        DispatchQueue.main.async {
            on.present(self.imagePicker, animated: true) {
                self.completion = completion
            }
        }
    }
    
    func showAlert(on view: UIViewController,  completion: @escaping (_ image: Any, _ name: String)->()){

        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localize, style: .default, handler: { [weak self] (_) in
            self?.pickImageFromGallery(on: view, completion: completion, .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library".localize, style: .default, handler: { [weak self] (_) in
            self?.pickImageFromGallery(on: view, completion: completion)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate methods
extension PhotoServices: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imgName: String = ""
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            
            print(imgName)
            imgName = imgUrl.lastPathComponent
        }
        if let image = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(image, imgName)
                }
            }
        } else if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(image, imgName)
                }
            }
        } else if let videoURL = info[.mediaURL] as? URL {
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    self.completion?(videoURL, imgName)
                }
            }
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIImage {
    public static func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat = 320) -> UIImage? {

        guard let imgRef = imageSource.cgImage else {
            return nil
        }

        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)

        var bounds = CGRect(x: 0, y: 0, width: width, height: height)

        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {

            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }

        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))

        switch(imageSource.imageOrientation) {
        case .up:
            transform = .identity
        case .upMirrored:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: 0)
                .scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: imageSize.height)
                .rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.height)
                .scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.width)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: imageSize.width)
                .scaledBy(x: -1.0, y: 1.0)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: 0)
                .rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(scaleX: -1.0, y: 1.0)
                .rotated(by: CGFloat.pi / 2.0)
        }

        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }

            context.concatenate(transform)
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }

        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageCopy
    }
}
