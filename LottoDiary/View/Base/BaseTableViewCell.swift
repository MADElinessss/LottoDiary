//
//  BaseTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/27/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension UIView {
    func applyShadow() {
        layer.cornerRadius = 15
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.lightGray.cgColor
    }
}
