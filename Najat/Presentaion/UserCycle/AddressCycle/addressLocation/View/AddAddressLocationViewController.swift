//
//  AddAddressLocationViewController.swift
//  Najat
//
//  Created by rania refaat on 22/07/2024.
//

import UIKit
import GoogleMaps

class AddAddressLocationViewController: BaseController {

    @IBOutlet private weak var currentLocationLabel: UILabel!
    @IBOutlet private weak var containerMapView: UIView!
   
    private lazy var locationMaster = LocationMaster(delegate: self)
    
    var addressItem: AddressViewModel = .init(lat: 0, lng: 0, address: "")
    private var delegate: PassLocation
    
    var mapView = GMSMapView()
    
    init(delegate: PassLocation) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleMap()

    }
    @IBAction private func didTapCurrentLocation(_ sender: Any) {
        setCurrentLocation()
    }
    private func setCurrentLocation(){
        let camera = GMSCameraPosition.camera(withLatitude: locationMaster.userLatitude, longitude: locationMaster.userLongitude, zoom: 13.0)
        LocationMaster.getAddressOfLocation(lat: locationMaster.userLatitude, lng: locationMaster.userLongitude)
            .sink {[weak self] address in
                guard let self else { return }
                
                currentLocationLabel.text = address.address
            }.store(in: &cancellable)
        mapView.animate(to: camera)
    }
    @IBAction private func didTapConfirm(_ sender: Any) {
        delegate.passAddress(addressItem)
        popMe()
    }
}

extension AddAddressLocationViewController: GMSMapViewDelegate {
    private func setupGoogleMap() {
        locationMaster.checkAuthorizationStatus()
        centerMapOnUserLocation()
    }
    
    private func setLocationMark() {
        if addressItem.lat == 0 {
            mapView = GMSMapView(frame: .init())
            mapView.frame = self.view.bounds
//            mapView.camera = camera
            mapView.delegate = self
            self.containerMapView.addSubview(mapView)
            setCurrentLocation()
            setPanGestureOnMap()
            
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: addressItem.lat, longitude: addressItem.lng, zoom: 13.0)
            mapView = GMSMapView(frame: self.view.bounds, camera: camera)
            mapView.delegate = self
            self.containerMapView.addSubview(mapView)
            mapView.animate(to: camera)
            setPanGestureOnMap()

        }
    }
}
extension AddAddressLocationViewController {
    
    private func setPanGestureOnMap() {
        mapView.settings.consumesGesturesInView = false
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
        panGesture.delegate = self
        mapView.isUserInteractionEnabled = true

        mapView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func panHandler(_ pan: UIPanGestureRecognizer) {
        if pan.state == .ended {
            let mapSize = mapView.frame.size
            let point = CGPoint(x: mapSize.width / 2, y: mapSize.height / 2)
            let coordinate = mapView.projection.coordinate(for: point)
            
            LocationMaster
                .getAddressOfLocation(lat: coordinate.latitude, lng: coordinate.longitude)
                .sink(receiveValue: {[weak self] address in
                    guard let self = self else {return}
                    addressItem.lat = coordinate.latitude
                    addressItem.lng = coordinate.longitude
                    addressItem.address = address.title
                    self.currentLocationLabel.text = address.title
                }).store(in: &cancellable)
        }else{
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
extension AddAddressLocationViewController: LocationMasterDelegate {
    
    func locationUpdated(location: CLLocation?) {
        guard let lat = location?.coordinate.latitude, let lng =  location?.coordinate.longitude else {return}
        
        LocationMaster.getAddressOfLocation(lat: lat, lng: lng)
            .sink {[weak self] address in
                guard let self else { return }
                if addressItem.address == "" {
                    currentLocationLabel.text = address.address
                } else {
                    currentLocationLabel.text = addressItem.address
                }
                addressItem.lat = lat
                addressItem.lng = lng
                addressItem.address = currentLocationLabel.text ?? ""
                locationMaster.locationManger.stopUpdatingLocation()
            }.store(in: &cancellable)
    }
    
    func showAlertPermission() {
        alertPermission()
    }
    
    func centerMapOnUserLocation() {
        setLocationMark()
    }
}

protocol PassLocation{
    func passAddress(_ address: AddressViewModel)
}

struct AddressViewModel{
    var lat: Double
    var lng: Double
    var address: String
}
