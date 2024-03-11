//
//  DiaryViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//


import SnapKit
import UIKit

class DiaryViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let floatingActionButton = UIButton()
    
    let viewModel = DiaryViewModel()

    var dataSource: UICollectionViewDiffableDataSource<Int, Diary>!
    
//    var list = [
//        Diary(content: "오늘은 돼지꿈을 꿨따", tag: "#맥북 m3", imageName: "example", colorString: "red")
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputViewWillAppearTrigger.value = ()
        
        let rightButton = createBarButtonItem(imageName: "line.3.horizontal.decrease", action: #selector(rightButtonTapped))
        configureNavigationBar(title: "로또 일기장", leftBarButton: nil, rightBarButton: rightButton)
        
        setConstraints()
        makeCellRegistration()
        updateSnapshot()
        setupFloatingActionButton()
    }

    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
        snapshot.appendSections([1,2])
        snapshot.appendItems(viewModel.outputDiary.value, toSection: 1)
//        snapshot.appendItems([Diary(content: "재수가 안좋은 날이었따. 나는 3가지 재수업는 일이 반복되면 로또를 산다.", tag: "#캠핑카", imageName: "example", colorString: "yellow")], toSection: 2)
        dataSource.apply(snapshot)
    }
    
    private func makeCellRegistration() {
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: "DiaryCell")

        dataSource = UICollectionViewDiffableDataSource<Int, Diary>(collectionView: collectionView, cellProvider: { collectionView, indexPath, diary in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as! DiaryCollectionViewCell
            cell.configure(with: diary)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        layout.configuration = configuration
        
        return layout
    }
    
    private func setConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
        }
        collectionView.backgroundColor = .background
    }
    
    // MARK: 일기 추가 플로팅 버튼
    private func setupFloatingActionButton() {
        let floatingActionButton = UIButton(frame: .zero)
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingActionButton)
        
        let pencilImage = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        floatingActionButton.setImage(pencilImage, for: .normal)
        
        floatingActionButton.backgroundColor = .pointSymbol
        floatingActionButton.tintColor = .white
        floatingActionButton.layer.cornerRadius = 28
        
        NSLayoutConstraint.activate([
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingActionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            floatingActionButton.widthAnchor.constraint(equalToConstant: 56),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        floatingActionButton.addTarget(self, action: #selector(floatingActionButtonTapped), for: .touchUpInside)
    }
    
    @objc func floatingActionButtonTapped() {
        let vc = AddDiaryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func rightButtonTapped() {
        // TODO: 정렬
        
    }
}
