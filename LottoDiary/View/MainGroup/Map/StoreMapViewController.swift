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
    var isInitialLocationUpdate = true
    var viewModel = MapViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let location = viewModel.selectedLocation.value {
            print("📌 viewWillAppear - Moving Camera to New Location: \(location.latitude), \(location.longitude)")
            moveToLocation(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        loadAndDisplayData()
        // 현위치 버튼 추가
        addCurrentLocationButton()
        
        viewModel.selectedLocation.bind { [weak self] location in
            guard let self = self, let location = location else { return }
            self.moveToLocation(latitude: location.latitude, longitude: location.longitude)
        }
        
    }
    
    override func addViews() {
        // super.addViews()
        let location = viewModel.selectedLocation.value
        let defaultPosition: MapPoint = MapPoint(longitude: location?.longitude ?? 126.98269592885, latitude: location?.latitude ?? 37.5646498601155)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        let result = mapController?.addView(mapviewInfo)
        print("🐖addViews called, result: \(String(describing: result))")
        
        
        mapController?.addView(mapviewInfo)
        addPoiAtLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPoiAtLocation() // 확실한 지도 뷰 준비 후 POI 추가
    }
    
    func moveToLocation(latitude: Double, longitude: Double) {
        print("📌 Attempting to Move Camera to Location: \(latitude), \(longitude)")
        DispatchQueue.main.async {
            let mapPoint = MapPoint(from: .init(longitude: longitude, latitude: latitude))
            if let mapView = self.mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: mapPoint, zoomLevel: 15, mapView: mapView)
                mapView.moveCamera(cameraUpdate)
                print("📌 Camera Movement Executed.")
            }
        }
    }

    func addPoiAtLocation() {
        guard let mapView = self.mapController?.getView("mapview") as? KakaoMap else { return }
        let manager = mapView.getLabelManager()
        
        // POI 스타일 설정
        if let originalImage = UIImage(named: "marker") {
            // 이미지 색상 변경 및 리사이징
            let tintedImage = originalImage.withTintColor(.blue, renderingMode: .alwaysOriginal)
            let resizedImage = resizeImage(image: tintedImage, targetSize: CGSize(width: 100, height: 100))
            
            let iconStyle = PoiIconStyle(symbol: resizedImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let poiStyle = PoiStyle(styleID: "customStyleSeoulCityHall", styles: [PerLevelPoiStyle(iconStyle: iconStyle, level: 0)])
            manager.addPoiStyle(poiStyle)
        }
        
        // POI 레이어 생성 및 POI 추가
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
        
        let poiOption = PoiOptions(styleID: "customStyleSeoulCityHall")
        let location = viewModel.selectedLocation
        let seoulCityHallPoint = MapPoint(longitude: location.value?.longitude ?? 126.98269592885, latitude: location.value?.latitude ?? 37.5646498601155)
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poi = layer?.addPoi(option: poiOption, at: seoulCityHallPoint)
        
        poi?.show() // POI 표시
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }

    
    func loadAndDisplayData() {
        fetchSearchResults { [weak self] searchResult in
            DispatchQueue.main.async {
                // self?.addDataPois(searchResult: searchResult)
                self?.onSearchResultReceived?(searchResult.documents ?? [])
            }
        }
    }
    
    func fetchSearchResults(completion: @escaping (SearchResult) -> Void) {
        if let location = locationManager.location {
            print("🍀", location)
            APIManager.shared.kakaoMapCallRequest(areaX: location.coordinate.latitude, areaY: location.coordinate.longitude) { result in
                switch result {
                case .success(let searchResult):
                    completion(searchResult)
                case .failure(let error):
                    print(error) // 오류 처리
                }
            }
        } else {
            APIManager.shared.kakaoMapCallRequest(areaX: 127.06283102249932, areaY: 37.514322572335935) { result in
                switch result {
                case .success(let searchResult):
                    completion(searchResult)
                case .failure(let error):
                    print(error) // 오류 처리
                }
            }
        }
    }

    private func handleError(_ error: AFError) {
        var message = "🐖알 수 없는 오류가 발생했습니다."
        
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
        guard let location = locations.last else { return }
        
        // 처음 위치 업데이트 시에만 현위치로 지도 이동
        if isInitialLocationUpdate {
            let mapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            if let mapView = self.mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: mapPoint, zoomLevel: 15, mapView: mapView)
                mapView.moveCamera(cameraUpdate)
            }
            // 첫 위치 업데이트 후 플래그를 false로 설정하여 추가 이동을 방지
            isInitialLocationUpdate = false
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
