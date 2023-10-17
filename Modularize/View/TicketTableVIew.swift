//
//  TicketTableVIew.swift
//  Modularize
//
//  Created by FAO on 20/09/23.
//

import UIKit

class TicketCollectionView: UIView, UICollectionViewDelegate {
   
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(
            section: createHorizontalLayout()
        )
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(
            TicketCardCell.self,
            forCellWithReuseIdentifier: TicketCardCell.cellIdentifier
        )
        cv.register(
            NoTicketPlaceHolder.self,
            forCellWithReuseIdentifier: NoTicketPlaceHolder.cellIdentifier
        )
        cv.isScrollEnabled = false
        return cv
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        addConstraints()
    }
    
    static func createHorizontalLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.82)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func addConstraints() {
        addConstraintsToFullScreen(to: collectionView)
         }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



