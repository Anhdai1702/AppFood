//
//  CustomViewTableViewCell.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 7/8/24.
//

import UIKit

class CustomViewTableViewCell: UITableViewCell {
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var midName: UILabel!
    @IBOutlet weak var pointStar: UILabel!
    @IBOutlet weak var cell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }

}
