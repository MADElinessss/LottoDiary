//
//  RandomNumberMakerViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/14/24.
//

import CollectionViewPagingLayout
import UIKit
import SwiftUI

class RandomNumberMakerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
        cell.titleLabel.text = title[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            print("😘")
            let hostingController = UIHostingController(rootView: OneRandomNumberView())
            navigationController?.pushViewController(hostingController, animated: true)
        }
    }

}
