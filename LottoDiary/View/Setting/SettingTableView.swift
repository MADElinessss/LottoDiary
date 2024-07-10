//
//  SettingTableView.swift
//  LottoDiary
//
//  Created by Madeline on 4/3/24.
//

import UIKit

class SettingTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    // Subscript
    private var items: [(title: String, icon: String)] = [
        ("알림 설정", "bell.circle.fill"),
        ("개인정보 처리방침", "info.circle.fill"),
        ("문의하기", "bubble.circle.fill")
    ]
    
    subscript(index: Int) -> (title: String, icon: String) {
        return items[index]
    }
    
    var didSelectItemAtIndex: ((Int) -> Void)?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        separatorStyle = .none
        layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self[indexPath.row]
        cell.textLabel?.text = item.title
        let cellImage = UIImage(systemName: item.icon)?.withTintColor(.pointSymbol, renderingMode: .alwaysOriginal)
        cell.imageView?.image = cellImage
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemAtIndex?(indexPath.row)
    }
}
