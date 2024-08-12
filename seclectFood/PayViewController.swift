
import UIKit

class PayViewController: UIViewController {
    
    @IBOutlet weak var priceOrder: UILabel!
    @IBOutlet weak var taxes: UILabel!
    @IBOutlet weak var priceDelivery: UILabel!
    @IBOutlet weak var sumTotal: UILabel!
    @IBOutlet weak var masterCard: UIButton!
    @IBOutlet weak var visa: UIButton!
    @IBOutlet weak var squares: UIImageView!
    @IBOutlet weak var sumPrice: UILabel!
    @IBOutlet weak var payNow: UIButton!
    @IBOutlet weak var imaSquares: UIImageView!
    @IBOutlet weak var priceTaxes: UILabel!
    var sum = 0
    var squaresChange = false
    var price : Float?
    var priceDeliveryData : MenuFood?
    var newData = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterCard.layer.cornerRadius = 10
        visa.layer.cornerRadius = 10
        payNow.layer.cornerRadius = 10
        imaSquares.layer.cornerRadius = 5
        imaSquares.layer.masksToBounds = true
        priceTaxes.text = "0.5"
        priceOrder.text = newData
        sumPrice.text = newData
        sumTotal.text = newData
        priceDelivery.text = "2"
        guard let priceDeliveryData = priceDeliveryData else {
            return
        }
        priceDelivery.text = priceDeliveryData.call
        if let price = price {
            priceOrder.text = "\(price)"
        }
        calculateSum()
    }
    
    func calculateSum() {
        // Lấy giá trị văn bản từ các UILabel
        guard let label1Text = priceOrder.text,
              let label2Text = priceTaxes.text,
              let label3Text = priceDelivery.text,
              // Chuyển đổi giá trị văn bản thành kiểu Double
              let label1Value = Double(label1Text),
              let label2Value = Double(label2Text),
              let label3Value = Double(label3Text) else {
            print("Error: Cannot convert text to number.")
            return
        }
        
        // Thực hiện phép cộng
        let sum = label1Value + label2Value + label3Value
        print("Total: \(sum)")
        
        // Gán kết quả vào resultLabel
        sumTotal.text = "\(sum)"
        sumPrice.text = "\(sum)$"
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeSquares(_ sender: Any) {
        self.squaresChange = !self.squaresChange
        if squaresChange {
            squares.image = UIImage(named: "squares")
        }
        else {
            squares.image = UIImage(named: "squares1")
        }
    }
    
    
    @IBAction func masterCard(_ sender: Any) {
        self.squaresChange = !self.squaresChange
        if squaresChange {
            masterCard.layer.backgroundColor = UIColor.red.cgColor
            visa.layer.backgroundColor = UIColor.tertiarySystemGroupedBackground.cgColor
        }
        else {
            masterCard.layer.backgroundColor = UIColor.tertiarySystemGroupedBackground.cgColor
        }
    }
    
    @IBAction func visa(_ sender: Any) {
        self.squaresChange = !self.squaresChange
        if squaresChange {
            visa.layer.backgroundColor = UIColor.red.cgColor
            masterCard.layer.backgroundColor = UIColor.tertiarySystemGroupedBackground.cgColor
        }
        else {
            visa.layer.backgroundColor = UIColor.tertiarySystemGroupedBackground.cgColor
        }
        
    }
    
    @IBAction func payNow(_ sender: Any) {
        let vc = FishishViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
