//
//  SeclectFoodViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 8/7/24.
//

import UIKit

class SeclectFoodViewController: UIViewController {
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pointStar: UILabel!
    @IBOutlet weak var intro: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var sl: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var oder: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    var incDecVal = 1
    @IBOutlet weak var price: UILabel!
    var priceandSL : Float?
    var partdata = [MenuFood]()
    var seclectIma : MenuFood?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let seclectIma = seclectIma else { return }
        
        if let url = URL(string: seclectIma.avatar) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("No image data received")
                    return
                }
                DispatchQueue.main.async {
                    self.ima.image = UIImage(data: data)
                }
            }.resume()
        }
        name.text = seclectIma.name
        pointStar.text = seclectIma.id
        intro.text = seclectIma.intro
        price.text = (seclectIma.price ?? "") + "$"
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.thumbTintColor = .red
        slider.value = 0
        money.layer.cornerRadius = 10
        oder.layer.cornerRadius = 10
        money.layer.masksToBounds = true
        sl.text = "\(incDecVal)"
        price.layer.cornerRadius = 10
        price.layer.masksToBounds = true
        priceandSL = Float(seclectIma.price!)
        updateLabel()
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func slider(_ sender: Any) {
        updateLabel()
    }
    
    @IBAction func minus(_ sender: Any) {
        if incDecVal > 1 {
            incDecVal -= 1
            sl.text = "\(incDecVal)"
        }
        updatePrice()
        
    }
    
    @IBAction func plus(_ sender: Any) {
        if incDecVal < 10 {
            incDecVal += 1
            sl.text = "\(incDecVal)"
        }
        updatePrice()
    }
    
    private func updateLabel() {
        let intValue = Int(slider.value.rounded())
        percent.text = "\(intValue)"
    }
    
    private func updatePrice() {
        guard let basePrice = Float(seclectIma?.price ?? "0") else { return }
        priceandSL = Float(basePrice) * Float(incDecVal)
        price.text = "\(priceandSL ?? 0)$"
    }
    @IBAction func buyNow(_ sender: Any) {
        let vc = PayViewController()
        vc.price = priceandSL
        vc.priceDeliveryData = seclectIma
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
