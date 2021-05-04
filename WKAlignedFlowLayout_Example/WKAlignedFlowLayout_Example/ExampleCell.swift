
import UIKit

import SnapKit


final class ExampleCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .green
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 25.0
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(self.label)
        
        self.label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12.0)
            make.trailing.equalToSuperview().offset(-12.0)
            make.height.equalTo(50.0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.label.text = nil
    }
    
    func setText(_ text: String) {
        self.label.text = text
    }
}
