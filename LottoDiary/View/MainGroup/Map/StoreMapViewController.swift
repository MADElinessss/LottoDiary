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
        self.view.backgroundColor = .blue
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
    
    // API 호출 결과 처리 및 POI 추가
    func loadAndDisplayData() {
        fetchSearchResults { [weak self] searchResult in
            DispatchQueue.main.async {
                self?.addDataPois(searchResult: searchResult)
                self?.onSearchResultReceived?(searchResult.documents ?? [])
            }
        }
    }
    
    func fetchSearchResults(completion: @escaping (SearchResult) -> Void) {
        // API 호출을 통해 SearchResult를 로드하고, 결과를 completion 콜백으로 전달합니다.
        // 이 부분은 프로젝트에 따라 API 호출 구현에 맞게 작성해야 합니다.
        
        APIManager.shared.kakaoMapCallRequest(areaX: 127.06283102249932, areaY: 37.514322572335935)
        
    }
    
    
    func addDataPois(searchResult: SearchResult) {
        guard let documents = searchResult.documents else { return }
        
        // 기존의 SF Symbols 아이콘 사용과 iconStyle, poiStyle 설정 부분은 유지합니다.
        let view = self.mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()

        // 커스텀 스타일을 생성하고, POI에 적용합니다. (이 부분은 이전 설정을 유지)
        // 예를 들어, SF Symbols에서 'star.fill' 아이콘을 사용하여 아이콘을 생성합니다.
        let originalIcon = UIImage(systemName: "star.fill")!.withTintColor(.yellow, renderingMode: .alwaysOriginal) // 색상 변경을 위해 withTintColor 사용
        let iconStyle = PoiIconStyle(symbol: originalIcon, anchorPoint: CGPoint(x: 0.5, y: 1.0)) // anchorPoint 조정
        let poiStyle = PoiStyle(styleID: "customStyle", styles: [PerLevelPoiStyle(iconStyle: iconStyle, padding: -2.0, level: 0)])
        manager.addPoiStyle(poiStyle)

        documents.forEach { document in
            if let x = Double(document.x), let y = Double(document.y) {
                // MapPoint 생성 시 from 대신 geoCoord 사용
                let mapPoint = MapPoint(from: .init(longitude: x, latitude: y))

                // PoiOptions를 생성하여, 각 문서(장소) 정보를 지도에 추가합니다.
                let poiOptions = PoiOptions(styleID: "customStyle")
                poiOptions.addText(PoiText(text: document.placeName, styleIndex: 0)) // 장소 이름을 텍스트로 추가

                // manager.addPoi(poiOptions, at: mapPoint)
                // 현재 예제에서는 POI 스타일만 설정하고, 실제 POI 추가는 SDK 문서를 참조해야 함.
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
