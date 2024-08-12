

import UIKit

class HeartTableViewCell: UITableViewCell {
    @IBOutlet weak var imaHeart: UIImageView!
    @IBOutlet weak var nameHeart: UILabel!
    @IBOutlet weak var midName: UILabel!
    @IBOutlet weak var cellCollec: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var reduce: UIButton!
    @IBOutlet weak var increase: UIButton!
    @IBOutlet weak var sl: UILabel!
    var incDecVal = 1
    var priceAndSL : Float?
    var onPriceChange: ((Float) -> Void)?
    var indexPath: IndexPath?  // Biến để theo dõi IndexPath của ô hiện tại

    var initialPrice: Post? {
        didSet {
            guard let initialPrice = initialPrice else { return }
            price.text = initialPrice.price
            sl.text = "\(incDecVal)"
            updatePrice()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func reduce(_ sender: Any) {
        if incDecVal > 1 {
            incDecVal -= 1
            sl.text = "\(incDecVal)"
        }
        updatePrice()
        
    }
    
    @IBAction func increase(_ sender: Any) {
        if incDecVal < 10 {
            incDecVal += 1
            sl.text = "\(incDecVal)"
        }
        updatePrice()
    }
    
    private func updatePrice() {
        guard let basePrice = Float(initialPrice?.price ?? "0") else { return }
        let priceAndSL = basePrice * Float(incDecVal)
        price.text = "\(priceAndSL)$"
        onPriceChange?(priceAndSL)
    }

    
}
