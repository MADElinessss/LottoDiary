//
//  AdBannerTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 6/7/24.
//

import GoogleMobileAds
import SnapKit
import UIKit

class AdBannerTableViewCell: BaseTableViewCell {
    
    let bannerView = GADBannerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureAd()
        contentView.backgroundColor = .adBackGround
    }
    
    func configureAd() {
        
        contentView.addSubview(bannerView)
        
        bannerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        bannerView.adUnitID = APIKey.googleAdKey
        bannerView.load(GADRequest())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
