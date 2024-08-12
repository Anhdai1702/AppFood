
//  Created by Phùng Anh Đài  on 8/7/24.

import UIKit

protocol HomeMenuCollectionViewCellDelegate: AnyObject {
    func didTapHeart(on cell: HomeMenuCollectionViewCell)
}

//protocol HeartDataUpdateDelegate: AnyObject {
//    func didUpdateHeartData()
//}


protocol HeartChangeDelegate: AnyObject {
    func heartCountDidChange(newCount: Int)
    
}
class HomeMenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pointStar: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var middleName: UILabel!
    var count = 0
    var indexPath: IndexPath?
    
    var heartChange : Bool = false {
        didSet {
            let imageName = heartChange ? "heart3" : "heart-2"
            heart.image = UIImage(named: imageName)
        }
    }
    
//    weak var delegates: HeartDataUpdateDelegate?
    weak var delegate: HeartChangeDelegate?
    weak var delegatess: HomeMenuCollectionViewCellDelegate? // Khai báo delegate
    var cellIndexPath: IndexPath? // Để lưu trữ indexPath của cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func heart(_ sender: Any) {
        handleHeartChange()
        
    }
    func  handleHeartChange() {
        self.heartChange = !self.heartChange
        delegate?.heartCountDidChange(newCount: heartChange ? 1 : -1)
        if let delegate = delegatess {
            delegate.didTapHeart(on: self)
        }
    }
}
