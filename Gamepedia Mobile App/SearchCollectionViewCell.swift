//
//  SearchCollectionViewCell.swift
//  Gamepedia Mobile App
//
//  Created by Jay on 12/8/16.
//  Copyright © 2016 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel?
    var imageView: UIImageView?
    
    override init(frame aFrame: CGRect) {
        super.init(frame: aFrame)
        setup()
        setupImage()
        self.backgroundColor = UIColor(red: 234/256, green: 234/256, blue: 234/256, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let width = self.bounds.width
        let height = self.bounds.height
        let frame = CGRect(x: 0, y: height-(height*0.2), width: width, height: height * 0.2)
        textLabel = UILabel(frame: frame)
        textLabel?.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1)
        textLabel?.textAlignment = .center
        textLabel?.font = UIFont (name: "HelveticaNeue-Bold", size: 17)
        textLabel?.textColor = UIColor.white
        self.addSubview(textLabel!)
    }
    
    func setupImage() {
        let width = self.bounds.width
        let height = self.bounds.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height * 0.8)
        imageView = UIImageView(frame: frame)
        imageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(imageView!)
    }
}
