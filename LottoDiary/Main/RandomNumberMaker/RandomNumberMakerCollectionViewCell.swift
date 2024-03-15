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
            width: frame.width*0.5,
            height: frame.height*0.7
        )
        card = UIView(frame: cardFrame)
        card.backgroundColor = .white
        contentView.addSubview(card)
    }
}

extension RandomNumberMakerCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
