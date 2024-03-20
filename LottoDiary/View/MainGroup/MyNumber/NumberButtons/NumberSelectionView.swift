//
//  NumberSelectionViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/14/24.
//

import SnapKit
import UIKit

class NumberSelectionView: UIView {
    
    enum Section {
        case main
    }
    
    // 선택된 번호가 변경될 때 호출할 Closure
    var onNumberSelected: (([Int]) -> Void)?
    
    // 이전에 선택한 번호를 관리
    var selectedNumbers: [Int] = []
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NumberSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = indexPath.item + 1

        if let index = selectedNumbers.firstIndex(of: number) {
            selectedNumbers.remove(at: index)
        } else {
            if selectedNumbers.count < 6 {
                selectedNumbers.append(number)
            }
        }

        selectedNumbers.sort()
        
        onNumberSelected?(selectedNumbers)
        updateUI()
    }

    func updateUI() {
        for case let cell as TextCell in collectionView.visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell),
                  let number = dataSource.itemIdentifier(for: indexPath) else { continue }
            
            cell.layer.borderWidth = selectedNumbers.contains(number) ? 2 : 0
            cell.layer.borderColor = selectedNumbers.contains(number) ? UIColor(named: "point")?.cgColor : UIColor.clear.cgColor
        }
    }
}



extension NumberSelectionView {
    /// - Tag: Inset
    func createLayout() -> UICollectionViewLayout {
        let itemWidth = (UIScreen.main.bounds.width) * 0.125
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                              heightDimension: .absolute(itemWidth))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.07))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func updateUIForNumber(_ number: Int, isSelected: Bool) {
        guard let indexPath = dataSource.indexPath(for: number) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? TextCell else { return }
        
        cell.layer.borderWidth = isSelected ? 2 : 0
        cell.layer.borderColor = isSelected ? UIColor(named: "point")?.cgColor : UIColor.clear.cgColor
    }
}

extension NumberSelectionView {
    
//    func configureHierarchy() {
//        collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//        addSubview(collectionView)
//    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            
            cell.label.text = "\(identifier)"
            cell.label.font = .systemFont(ofSize: 14, weight: .semibold)
            cell.label.textColor = .white
            cell.contentView.backgroundColor = self.color(for: identifier)
            cell.label.textAlignment = .center
            cell.clipsToBounds = true
            let itemWidth = (UIScreen.main.bounds.width) * 0.1
            cell.layer.cornerRadius = itemWidth / 2
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...45))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func color(for drawNumber: Int) -> UIColor {
        switch drawNumber {
        case 1...10:
            return UIColor(named: "lotteryYellow") ?? .yellow
        case 11...20:
            return UIColor(named: "lotteryBlue") ?? .blue
        case 21...30:
            return UIColor(named: "lotteryRed") ?? .red
        case 31...40:
            return UIColor(named: "lotteryGray") ?? .gray
        case 41...45:
            return UIColor(named: "lotteryGreen") ?? .green
        default:
            return .lightGray
        }
    }
}

