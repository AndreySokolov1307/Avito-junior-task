//
//  ViewController.swift
//  Avito junior test task
//
//  Created by Андрей Соколов on 25.12.2023.
//

import UIKit

class OfferViewController: UIViewController {
    
    private var offerView: OfferView! = nil
    
    private var offersInfo: OffersInfo! = nil
    
    private var dataSource: UICollectionViewDiffableDataSource<String, OfferList>! = nil
    private var snapshot: NSDiffableDataSourceSnapshot<String, OfferList> {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, OfferList>()
        snapshot.appendSections(["OfferList"])
        snapshot.appendItems(offersInfo!.result.list)
        return snapshot
    }
    override func loadView() {
        offerView = OfferView()
        self.view = offerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        congifureCollectionViewDataSource()
        fetchOffersInfo()
    }
    
    private func setupCollectionView() {
        
        offerView.collectionView.register(OfferCell.self, forCellWithReuseIdentifier: OfferCell.reuseIdentifier)
        offerView.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        offerView.collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier)
        offerView.collectionView.delegate = self
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    private func fetchOffersInfo() {
        do {
            offersInfo = try OfferController.shared.fetchOffersInfo()
            changeAllIsSelectedToFalse()
        } catch {
            print(error)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func congifureCollectionViewDataSource()  {
        dataSource = UICollectionViewDiffableDataSource<String, OfferList>(collectionView: offerView.collectionView, cellProvider: {(collectionView, indexPath, offer) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCell.reuseIdentifier, for: indexPath) as! OfferCell
            cell.checkMarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            
            Task {
                do {
                    if let iconImageURL = URL(string: offer.icon.imageURL) {
                        let iconImage = try await OfferController.shared.fetchIconImage(with: iconImageURL)
                        cell.iconImageView.image = iconImage
                    }
                } catch {
                    print(error)
                }
            }
            cell.iconImageView.image = UIImage(systemName: "photo")
            cell.titleLabel.text = offer.title
            cell.descriptionLabel.text = offer.description
            cell.priceLabel.text = offer.price
            cell.checkMarkImageView.isHidden = !offer.isSelected
            cell.backgroundColor = .systemGroupedBackground
            cell.layer.cornerRadius = 8
            //Без этого иногда клетка была меньше чем надо
            cell.layoutIfNeeded()
            
            
            return cell
        })
        
        //MARK: - SupplementaryViewProvider
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
                
                headerView.label.text = self.offersInfo.result.title
                
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseIdentifier, for: indexPath) as! FooterView
    
                footerView.button.setTitle("Выбрать", for: .normal)
                footerView.button.addTarget(self, action: #selector(self.didTapSelectButton), for: .touchUpInside)
                
                return footerView
            }
        }
    }
    
    @objc func didTapSelectButton() {
        if let selectedOffer = offersInfo.result.list.first(where: { $0.isSelected }) {
            let alert = UIAlertController(title: selectedOffer.title , message: nil, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Понятно", style: .cancel)
            
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
    }
    func changeAllIsSelectedToFalse() {
        for i in 0..<offersInfo.result.list.count {
            offersInfo.result.list[i].isSelected = false
        }
    }
}

//MARK: - UICollectionViewDelegate

extension OfferViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        offersInfo.result.list[indexPath.row].isSelected.toggle()
        checkforOnlyOneSelectedAtIndex(indexPath.row)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func checkforOnlyOneSelectedAtIndex(_ index: Int) {
        for i in 0..<offersInfo.result.list.count where i != index {
            offersInfo.result.list[i].isSelected = false
        }
    }
}



