//
//  RandomNumberMakerCollectionViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/14/24.
//

import UIKit
import CollectionViewPagingLayout

class RandomNumberMakerCollectionViewCell: UICollectionViewCell {
    // The card view that we apply transforms on
    var card: UIView!
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // Adjust the card view frame
        // you can use Auto-layout too
        let cardFrame = CGRect(
            x: 80,
            y: 100,
            width: frame.width*0.7,
            height: frame.height*0.7
        )
        card = UIView(frame: cardFrame)
        card.backgroundColor = .card
        card.layer.cornerRadius = 20
        
        contentView.addSubview(card)
        card.addSubview(titleLabel)
        
        titleLabel.text = "오늘의 행운은?"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .pointSymbol
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(card)
            make.top.equalTo(card).inset(44)
        }
    }
}

extension RandomNumberMakerCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
