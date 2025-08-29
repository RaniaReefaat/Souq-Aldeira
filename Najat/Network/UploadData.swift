import SwiftUI

import UIKit

protocol UploadDataProtocol {
    var data: Data? { get set }
    var fileName: String { get set }
    var mimeType: String { get set }
    var name: String { get set }
    
}

struct UploadData: UploadDataProtocol {
    var data: Data?
    var fileName: String
    var mimeType: String
    var name: String
    var url: URL? = nil
    
    init(image: UIImage, name: String = "image") {
        self.data = image.jpegData(compressionQuality: 0.4)!
        self.name = name
        self.fileName = "\(name).jpeg"
        self.mimeType = "\(name)/jpeg"
    }
    
    init?(image: UIImage?, name: String?) {
        if let image = image, let name = name {
            self.data = image.jpegData(compressionQuality: 0.4)!
            self.name = name
            self.fileName = "\(name).jpeg"
            self.mimeType = "\(name)/jpeg"
        } else {
            return nil
        }
    }
    
    init(data: Data, name: String = "image") {
        self.data = data
        self.name = name
        self.fileName = "\(name).jpeg"
        self.mimeType = "\(name)/jpeg"
    }
    
    init(data: Data, name: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = "video.\(mimeType)"
        self.mimeType = "video/\(mimeType)"

    }
    
    init(data: Data, name: String, mimeType: String, fileName: String) {
        self.data = data
        self.name = name
        self.fileName = "\(fileName).\(mimeType)"
        self.mimeType = "\(fileName)/\(mimeType)"

    }
    
    init(url: URL, name: String) {
        self.url = url
        self.name = name
        self.fileName = url.absoluteString
        self.mimeType = ""
    }
}
