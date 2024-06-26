//
//  RandomNumberMakerViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/14/24.
//

import CollectionViewPagingLayout
import UIKit
import SwiftUI

class RandomNumberMakerViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        configureNavigationBar(title: "번호 생성기", rightBarButton: nil)
    }

    private func setupCollectionView() {
        let layout = CollectionViewPagingLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(RandomNumberMakerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RandomNumberMakerCollectionViewCell
        let title = ["랜덤 로또 번호", "랜덤 번호 추천"]
        let image = ["numbers", "anumber"]
        cell.titleLabel.text = title[indexPath.item]
        cell.imageView.image = UIImage(named: image[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            let hostingController = UIHostingController(rootView: OneRandomNumberView())
            navigationController?.pushViewController(hostingController, animated: true)
        } else {
            let vc = SixRandomNumbersViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
