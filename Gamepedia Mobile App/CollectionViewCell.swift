//
//  CollectionViewCell.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/8/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
