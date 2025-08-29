//
//  LocationMaster.swift
//  Captain One Driver
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//


import Foundation
import CoreLocation
import Combine

protocol LocationMasterDelegate: AnyObject {
    func current(speed: Double)
    func centerMapOnUserLocation()
    func locationUpdated(location: CLLocation?)
    func showAlertPermission()
}

extension LocationMasterDelegate {
    func current(speed: Double) { }
    func centerMapOnUserLocation() { }
    func locationUpdated(location: CLLocation?) { }
    func showAlertPermission(){}
}

class LocationMaster: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: LocationMasterDelegate?
    private(set) var locationManger = CLLocationManager()
    
    var oldState: CLAuthorizationStatus?
    
    var isLocationEnabled: Bool {
        return locationManger.location != nil
    }
    
    var userLocation: CLLocation?
    
    var userLongitude: Double {
        return userLocation?.coordinate.longitude ?? locationManger.location?.coordinate.longitude ?? 0.0
    }
    
    var userLatitude: Double {
        return userLocation?.coordinate.latitude ?? locationManger.location?.coordinate.latitude ?? 0.0
    }
    
    static func getAddressOfLocation(lat: Double, lng: Double) -> AnyPublisher<GoogleAddressModel, Never> {
        Future { promise in
            let location = CLLocation(latitude: lat, longitude: lng)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print(error ?? "Unknown Error")
                } else {
                    guard let placemark = placemarks?.first else { return }
                    let streetName = placemark.thoroughfare ?? ""
                    let area = placemark.administrativeArea ?? ""
                    let locality = placemark.locality ?? ""
                    let address = (streetName + " " + locality + " " + area)
                    promise(.success(GoogleAddressModel.init(title: address, address: address)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func getRoute(pickupPoint: UserLocationModel, firstDestination: UserLocationModel, secDestination: UserLocationModel?) -> AnyPublisher<RouteScreenData, MyAppError> {

        var path = "\(pickupPoint.lng),\(pickupPoint.lat);\(firstDestination.lng),\(firstDestination.lat)"
        if let secDestination {
            path.append(";\(secDestination.lng),\(secDestination.lat)")
        }

        let url = "https://router.project-osrm.org/route/v1/driving/\(path)?steps=true&geometries=geojson"

        print(url)

        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: OpenStreetMapResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError({ _ in
                MyAppError.basicError
            })
            .map({ model in
                RouteScreenData(model: model)
            })
            .eraseToAnyPublisher()
    }
    
    init(delegate: LocationMasterDelegate? = nil) {
        self.delegate = delegate
        super.init()
        locationManger.delegate = self
        oldState = locationManger.authorizationStatus
    }
    
    func checkAuthorizationStatus() {
        let authorizationStatus = locationManger.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            config()
        case .restricted:
            config()
        case .denied:
            config()
        case .authorizedAlways:
            config()
        case .authorizedWhenInUse:
            config()
        @unknown default:
            config()
        }
    }
    
    private func config() {
        locationManger.requestAlwaysAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.showsBackgroundLocationIndicator = true
        locationManger.startUpdatingLocation()
        userLocation = locationManger.location
        delegate?.centerMapOnUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location
        delegate?.locationUpdated(location: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.centerMapOnUserLocation()
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MARK: - Welcome
struct LocationFetchModel: Codable {
    let plusCode: PlusCode?
    let results: [ResultModel]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String?
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Result
struct ResultModel: Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress: String?
    let geometry: GeometryModel?
    let placeID: String?
    let plusCode: PlusCode?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct GeometryModel: Codable {
    let location: LocationResponse?
    let locationType: String?
    let viewport, bounds: Bounds?
    
    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport, bounds
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: LocationResponse?
}

struct GoogleAddressModel {
    let title: String
    let address: String
}
struct LocationResponse: Codable {
    let lat, lng: Double?
    let location: String?
}

struct UserLocationModel {
    
    init(lat: Double, lng: Double, address: String) {
        self.lat = lat
        self.lng = lng
        self.address = address
    }
    
    let lat: Double
    let lng: Double
    let address: String
    
    init(model: LocationResponse) {
        lat = model.lat ?? 0
        lng = model.lng ?? 0
        address = model.location ?? ""
    }
}
