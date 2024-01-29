//
//  CollectionViewCell2.swift
//  CollectionView_andScroll
//
//  Created by Anton on 29.01.24.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    static var reuseId: String = "Cell2"
    
    let friendName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .magenta
        addSubview(friendName)
        self.clipsToBounds = true
    }
    
    func configure(with chat: String) {
        friendName.text = chat
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
