//
//  MenuTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/10/24.
//

import SnapKit
import UIKit

final class MenuTableViewCell: UITableViewCell {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
    var onItemTapped: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    private func configureView() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        collectionView.backgroundColor = .background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        collectionView.isScrollEnabled = false
    }

    static func configureCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
    
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.44, height: UIScreen.main.bounds.width * 0.43)
        
        return layout
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MenuTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        let titles = ["나의 번호 목록","나의 당첨내역", "번호 생성기", "복권 판매점"]
        let imageNames = ["list", "win", "number", "map"]
        
        if indexPath.row < titles.count && indexPath.row < imageNames.count {
            cell.configure(with: titles[indexPath.row], imageName: imageNames[indexPath.row])
        }
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemTapped?(indexPath.item)
    }
}
