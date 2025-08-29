//
//  googleMap+.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import Foundation
import GoogleMaps

private struct MapPath: Decodable{
    var routes: [RouteMap]?
}

private struct RouteMap: Decodable{
    var overview_polyline: OverView?
}

private struct OverView: Decodable {
    var points: String?
}

extension GMSMapView {
    
    func camera(lat: Double, lng: Double, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom)
        self.camera = camera
    }
    
    //MARK:- Draw polygon
    func drawPath(with points: String) {
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = .blue
            polyline.map = self
        }
    }
    
    func drawPath(with path: GMSMutablePath) {
        DispatchQueue.main.async {
            let polyLine = GMSPolyline(path: path)
            polyLine.strokeWidth = 2.0
            polyLine.strokeColor = .blue
            polyLine.map = self
        }
    }
    
    func marker(lat: Double, lng: Double, color: UIColor) {
        let pos = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: pos)
        let picColor = color
        marker.icon = GMSMarker.markerImage(with: picColor)
        marker.map = self
    }
    
    @discardableResult
    func markerView(lat: Double, lng: Double, image: UIImage, title: String? = nil) -> GMSMarker {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        marker.title = title
        
        let imageView = UIImageView(image: image)
        marker.iconView = imageView
        marker.map = self
        return marker
    }
    
    @discardableResult
    func markerView(lat: Double, lng: Double, imageUrl: String, title: String? = nil) -> GMSMarker {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        marker.title = title
        UIImageView().load(with: imageUrl) { (_image) in
            guard let image = _image else {return}
            let imageView = UIImageView(image: image)
            imageView.withHeight(30)
            imageView.withWidth(30)
            marker.iconView = imageView
        }
        marker.map = self
        return marker
    }
}

extension UIViewController {
    func getCurrentLocation() -> (String, String) {
        let locManager = CLLocationManager()
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            guard let currentLocation = locManager.location else {
                return ("","")
            }
            let lat = currentLocation.coordinate.latitude.string
            let lng = currentLocation.coordinate.longitude.string
            return (lat,lng)
        }
        return ("","")
    } 
}

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}
