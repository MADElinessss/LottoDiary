//
//  StoreMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import CoreLocation
import KakaoMapsSDK
import UIKit

class StoreMapViewController: BaseMapViewController {

    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.2050543, latitude: 37.2911436)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        
        mapController?.addView(mapviewInfo)
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    override func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
    }

    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    override func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
}
