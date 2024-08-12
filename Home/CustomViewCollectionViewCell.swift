//
//  CustomViewCollectionViewCell.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 7/8/24.
//

import UIKit

class CustomViewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ima.layer.cornerRadius = 20
        ima.layer.masksToBounds = true
        
    }
    
}
