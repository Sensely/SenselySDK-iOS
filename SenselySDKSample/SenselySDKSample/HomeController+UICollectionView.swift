//
// HomeController+UICollectionView.swift 
//
// Created by David Mazza on 4/24/18.
//

import Foundation
import Chat_sensely.Swift

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func registerAllCellAndFootersForCV(_ collectionView: UICollectionView) {
        let cellNib = UINib(nibName: "HomeCell",
                            bundle: Bundle.main)
        let footerNib = UINib(nibName: "HomeFooter",
                              bundle: Bundle.main)
        
        collectionView.register(cellNib,
                                forCellWithReuseIdentifier: "HomeCell")
        collectionView.register(footerNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "HomeFooter")
    }
    
    func configureHomeCell(homeCell: HomeCell, indexPath: IndexPath) -> HomeCell {
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
    
    func installCollectionView() {
        
        var scrollInsetTop: CGFloat
        
        if senselyAvatarView.contentSize.height == 0 {
            scrollInsetTop = senselyAvatarView.frame.height
        } else {
            scrollInsetTop = senselyAvatarView.contentSize.height
        }
        
        collectionView.backgroundColor  = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: scrollInsetTop,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: view.frame.width, height: HomeController.footerHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width - 0, height: 60)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = layout
        }
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
        guard kind == UICollectionView.elementKindSectionFooter else {
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
            
            Configuration.assessmentID = String(indexPath.row)
            
            self.avatarController = AvatarModule(nibName: "AvatarViewController",
                                                       bundle: Bundle(for: AvatarModule.self))
            
            guard let avatar = self.avatarController else {
                fatalError("Avatar not loaded")
            }
            
            //self.avatarController?.tagCellNib = self.customTagCellNib // Custom Tag cell button
            //self.avatarController?.tagCellSize = CGSize(width: 150, height: 50)
            self.avatarController?.endOfSpeechTimeout = 2.5
            
            self.avatarController?.delegate = self
            self.avatarController?.assessmentIndex = Int(Configuration.assessmentID)!
            
            self.navigationController?.pushViewController(avatar, animated: true)
            
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
