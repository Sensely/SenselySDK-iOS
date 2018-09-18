//
// HomeController+UICollectionView.swift 
//
// Created by David Mazza on 4/24/18.
//

import Foundation
import Chat_sensely.Swift

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
    fileprivate func configureHomeCell(homeCell: HomeCell, indexPath: IndexPath) -> HomeCell {
        let anyHorizontalSizeClass = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.unspecified)
        homeCell.selectedBackgroundView = UIImageView.init(image: UIImage.init(named: "bg_home_cell",
                                                                               in: Bundle.main,
                                                                               compatibleWith: anyHorizontalSizeClass))
        homeCell.mainLabel.text = arrayWithNames[indexPath.row]
        homeCell.mainLabel.textColor = UIColor.darkGray
        if arrayWithImages[indexPath.row].count != 0 {
            homeCell.mainImageView.downloadImage(url: URL.init(string: arrayWithImages[indexPath.row])!)
        }
        homeCell.detailImageView.image = UIImage.init(named: "chevron")
        homeCell.defaultImageString = arrayWithImages[indexPath.row] as NSString
        homeCell.blueColor = Configuration.blueColor
        homeCell.mainImageView.tintColor = Configuration.blueColor
        return homeCell
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return arrayWithNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell",
                                                                for: indexPath) as? HomeCell else {
                                                                    fatalError("Unable to dequeue HomeCell")
        }
        return configureHomeCell(homeCell: homeCell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionFooter else {
            fatalError("Only supporting custom footer views")
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: "HomeFooter",
                                                               for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        heightForHeaderInSection section: Int) -> Float {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.arrayWithNames[indexPath.item] == AssessmentName.serviceFinder {
                self.performSegue(withIdentifier: HomeControllerSegue.serviceFinder.rawValue, sender: self)
            } else {
                
                let viewController = AvatarModule(nibName: "AvatarViewController",
                                                  bundle: Bundle(for: AvatarModule.self))
                viewController.assessmentIndex = indexPath.item
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
