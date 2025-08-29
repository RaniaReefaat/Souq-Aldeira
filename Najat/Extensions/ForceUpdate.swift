//
//  ForceUpdate.swift
//  Dukan
//
//  Created by Ahmed Taha on 28/08/2023.
//

import UIKit

fileprivate enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

extension UIViewController {
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version > currentVersion
        }
        throw VersionError.invalidResponse
    }
}
