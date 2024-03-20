//
//  StoreMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import CoreLocation
import KakaoMapsSDK
import UIKit
import Alamofire

class StoreMapViewController: BaseMapViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    let _layerNames: [String] = ["korea", "seoul", "busan"]
    var _radius: Float = 50.0
    var onSearchResultReceived: (([Document]) -> Void)?
    
    override func addViews() {
        print("🥐, addViews")
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🥐, viewDidLoad")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        loadAndDisplayData()
        // 현위치 버튼 추가
        addCurrentLocationButton()
        
    }
    
    override func viewInit(viewName: String) {
        print("🥐, viewInit")
        configurePoi()
    }
    
    func loadAndDisplayData() {
        
        fetchSearchResults()
    }
    
    func fetchSearchResults() {
        
        APIManager.shared.kakaoMapCallRequest(areaX: 127.06283102249932, areaY: 37.514322572335935, on: self) { [weak self] result in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    
                    self?.addDataPois(searchResult: searchResult)
                    self?.onSearchResultReceived?(searchResult.documents ?? [])
                }
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    private func handleError(_ error: AFError) {
        var message = "알 수 없는 오류가 발생했습니다."
        
        if let urlError = error.underlyingError as? URLError, urlError.code == .notConnectedToInternet {
            message = "네트워크 연결이 단절되었습니다.\n잠시 후 다시 시도해주세요."
        } else if error.isResponseSerializationError {
            message = "데이터 처리 중 오류가 발생했습니다."
        } else if error.isResponseValidationError {
            message = "서버로부터 유효하지 않은 응답이 왔습니다."
        }
        
        DispatchQueue.main.async {
            if let viewController = self.navigationController?.topViewController {
                AlertManager.shared.showAlert(on: viewController, title: "오류 발생", message: message)
            }
        }
    }
    
    func addDataPois(searchResult: SearchResult) {
        guard let documents = searchResult.documents else { return }
        
        let view = self.mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()

        let originalIcon = UIImage(systemName: "star.fill")!.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let iconStyle = PoiIconStyle(symbol: originalIcon, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let poiStyle = PoiStyle(styleID: "customStyle", styles: [PerLevelPoiStyle(iconStyle: iconStyle, padding: -2.0, level: 0)])
        manager.addPoiStyle(poiStyle)

        documents.forEach { document in
            if let x = Double(document.x), let y = Double(document.y) {
                let mapPoint = MapPoint(from: .init(longitude: x, latitude: y))

                let poiOptions = PoiOptions(styleID: "customStyle")
                poiOptions.addText(PoiText(text: document.placeName, styleIndex: 0))
            }
        }
    }

    func configurePoi() {
        // CreatePoiStyle
        print("🥐, CreatePoiStyle")
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let symbol = UIImage(systemName: "mappin.and.ellipse.circle.fill")
        
        _radius = Float((symbol?.size.width ?? 50) / 2.0)
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        let iconStyle = PoiIconStyle(symbol: symbol, anchorPoint: anchorPoint)
        
        let poiStyle = PoiStyle(styleID: "customStyle", styles: [
            // padding을 -2로 설정하면 패닝시 깜빡거리는 현상을 최소화 할 수 있다.
            PerLevelPoiStyle(iconStyle: iconStyle, padding: -2.0, level: 0)
        ])
        
        manager.addPoiStyle(poiStyle)
        
        // createLodLabelLayer skip
        
        
        // CreateLodPois
        print("🥐, CreateLodPois")
        
        
        for index in 0 ... 2 {
            let iconStyle = PoiIconStyle(symbol: symbol, anchorPoint: anchorPoint)
            let poiStyle = PoiStyle(styleID: "customStyle" + String(index), styles: [
                // padding을 -2로 설정하면 패닝시 깜빡거리는 현상을 최소화 할 수 있다.
                PerLevelPoiStyle(iconStyle: iconStyle, padding: -2.0, level: 0)
            ])
            
            manager.addPoiStyle(poiStyle)
        }
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
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
        let button = UIButton()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(50)
        }
        
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .point
        
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func moveToCurrentLocation() {
        if let location = locationManager.location {
            let mapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            if let mapView = self.mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: mapPoint, zoomLevel: 15, mapView: mapView)
                mapView.moveCamera(cameraUpdate)
            }
        }
    }
    
}
