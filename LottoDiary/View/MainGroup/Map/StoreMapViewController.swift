//
//  StoreMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import CoreLocation
import KakaoMapsSDK
import UIKit

class StoreMapViewController: BaseMapViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 현위치 버튼 추가
        addCurrentLocationButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let mapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            if let mapView = self.mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: mapPoint, zoomLevel: mapView.zoomLevel, mapView: mapView)
                mapView.moveCamera(cameraUpdate)
            }
        }
    }
    
    func addCurrentLocationButton() {
        let button = UIButton(frame: CGRect(x: 20, y: view.frame.size.height - 100, width: 50, height: 50))
        button.setImage(UIImage(named: "your_location_button_image"), for: .normal) // 'your_location_button_image'를 현위치 버튼 이미지로 설정하세요.
        button.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func moveToCurrentLocation() {
        if let location = locationManager.location {
            let mapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            if let mapView = self.mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: mapPoint, zoomLevel: mapView.zoomLevel, mapView: mapView)
                mapView.moveCamera(cameraUpdate)
            }
        }
    }
}
