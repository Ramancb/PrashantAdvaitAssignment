//
//  ImagesCollectionCell.swift
//  PrashantAdvaitAssignment
//
//  Created by Raman choudhary on 10/05/24.
//

import UIKit

class ImagesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder_banner")
        failedLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
