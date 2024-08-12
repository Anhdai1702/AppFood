//
//  HomeCollectionViewCell.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 8/7/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var ima: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.layer.cornerRadius = 20
        title.layer.masksToBounds = true
    }
    
}
