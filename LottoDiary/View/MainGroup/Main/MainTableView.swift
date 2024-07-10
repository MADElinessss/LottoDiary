//
//  MainTableView.swift
//  LottoDiary
//
//  Created by Madeline on 3/15/24.
//

import UIKit

class MainTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .background
        register(MyLottoTableViewCell.self, forCellReuseIdentifier: "MyLottoTableViewCell")
        register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        separatorStyle = .none
    }
}
