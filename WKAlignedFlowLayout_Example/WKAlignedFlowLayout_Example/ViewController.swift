
import UIKit

import SnapKit


final class ViewController: UIViewController {
    
    private let flowLayout: WKAlignedFlowLayout = {
        let flowLayout = WKAlignedFlowLayout(horizontalAlignment: .trailing, collectionViewWidth: UIScreen.main.bounds.width)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        collectionView.register(ExampleCell.self, forCellWithReuseIdentifier: ExampleCell.identifier)
        
        return collectionView
    }()
    
    private let data = ["Hello",
                        "My Name is",
                        "Seung Eon Lee",
                        "a.k.a wookeon",
                        "Nice to meet you",
                        "This is WKAlignedCollectionViewFlowLayout",
                        "creator_wookeon@naver.com",
                        "Thanks"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.data.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCell.identifier, for: indexPath) as? ExampleCell,
                let text = self.data[safe: indexPath.item]
            else {
                return UICollectionViewCell()
            }
            
            cell.setText(text)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


extension Collection {
    
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}


extension UICollectionViewCell {
    
    static let identifier = String(describing: self)
}
