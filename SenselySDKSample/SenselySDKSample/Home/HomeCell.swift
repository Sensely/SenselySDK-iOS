//
//  SSHomeCell.swift
//  SimpleChat
//
//  Created by Егор on 1/30/17.
//  Copyright © 2017 Logan Wright. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var btnLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var defaultImageString: NSString!
    var specialHighlightedArea: UIView?
    var blueColor: UIColor?

    override var isHighlighted: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    func onSelected(_ newValue: Bool) {
        if isHighlighted == true {
            if isSelected == false {
                mainImageView.tintColor = blueColor
                detailImageView.image = UIImage.init(named: "chevron")
                mainLabel.textColor = UIColor.darkGray
            } else {
                mainImageView.tintColor = UIColor.white
                detailImageView.image = UIImage.init(named: "chevronWhite")
                mainLabel.textColor = UIColor.white
            }
        } else {
            mainImageView.tintColor = UIColor.white
            detailImageView.image = UIImage.init(named: "chevronWhite")
            mainLabel.textColor = UIColor.white
        }
    }
}
