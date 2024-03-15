//
//  StoreMapViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import KakaoMapsSDK
import UIKit

class StoreMapViewController: BaseMapViewController {

    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.12481368747665, latitude: 37.54215842628883)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }

}
