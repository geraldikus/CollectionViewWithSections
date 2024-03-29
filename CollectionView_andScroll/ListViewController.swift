//
//  ViewController.swift
//  CollectionView_andScroll
//
//  Created by Anton on 24.01.24.
//

import UIKit
import SwiftUI

class ListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    var sections = [MSection]()
    
    var dataSource: UICollectionViewDiffableDataSource<MSection, MChat>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        createDataSource()
        addMockData()
        reloadData()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell1.self, forCellWithReuseIdentifier: CollectionViewCell1.identifier)
        
        collectionView.register(CollectionViewCell2.self, forCellWithReuseIdentifier: CollectionViewCell2.reuseId)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    // section -> groups -> items -> size
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layotEnvironment in
            
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case "Type1":
                return self.createVerticalSection()
            case "Type2":
                return self.createVerticalSection()
            default:
                return self.createHorizontalSection()
            }
        }
        
        return layout
    }
    
    func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(104), heightDimension: .estimated(88))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 20, bottom: 6, trailing: 12)
        
        let header = createSectionHeader()
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 20, bottom: 0, trailing: 20)
        
        let header = createSectionHeader()
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return layoutSectionHeader
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MSection, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            
            switch self.sections[indexPath.section].type {
            case "Type1":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell1.identifier, for: indexPath) as? CollectionViewCell1
                cell?.setupText(with: chat.lastMessage)
                return cell
                
            case "Type2":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell1.identifier, for: indexPath) as? CollectionViewCell1
                cell?.setupText(with: chat.lastMessage)
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell2.reuseId, for: indexPath) as? CollectionViewCell2
                cell?.configure(with: chat.friendName)
                return cell
            }
        })
        
        
        // For header
        
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { return nil }
            
            guard let firstItem = self.dataSource?.itemIdentifier(for: indexPath) else { return nil}
            
            guard let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            if section.title.isEmpty {
                return nil
            }
            
            sectionHeader.label.text = section.title
            
            return sectionHeader
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MSection, MChat>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }

    
    private func addMockData() {
        let chat1 = MChat(friendName: "Alice", friendImage: "alice_image", lastMessage: "Hello!")
        let chat2 = MChat(friendName: "Bob", friendImage: "bob_image", lastMessage: "Hi there!")
        let chat3 = MChat(friendName: "Charlie", friendImage: "charlie_image", lastMessage: "Hey!")
        let chat4 = MChat(friendName: "David", friendImage: "david_image", lastMessage: "Good morning!")
        let chat5 = MChat(friendName: "Eve", friendImage: "eve_image", lastMessage: "Good evening!")
        let chat6 = MChat(friendName: "Frank", friendImage: "frank_image", lastMessage: "How are you?")
        let chat7 = MChat(friendName: "Grace", friendImage: "grace_image", lastMessage: "Long time no see!")
        let chat8 = MChat(friendName: "Henry", friendImage: "henry_image", lastMessage: "What's up?")
        let chat9 = MChat(friendName: "Ivy", friendImage: "ivy_image", lastMessage: "Nice to meet you!")
        let chat10 = MChat(friendName: "Jack", friendImage: "jack_image", lastMessage: "See you later!")

        
        // Создаем секцию с моковыми данными
        let section = MSection(type: "Type1", title: "Friends Messages", items: [chat1, chat2, chat3])
        
        let section2 = MSection(type: "Type2", title: "Friends Old Messages", items: [chat4, chat5, chat6])
        
        let section3 = MSection(type: "Type3", title: "Friends Name", items: [chat7, chat8, chat9, chat10])
        
        // Код ниже: то, в каком порядке будут расположены секции
        
        sections.append(section3)
        sections.append(section)
        sections.append(section2)
    }
    
}

// MARK: - For Canvas

struct ViewRepreset: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ListViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewRepreset>) {
        
    }
    
}

struct CanvasView: View {
    var body: some View {
        ViewRepreset()
    }
}

#Preview {
    CanvasView()
}

