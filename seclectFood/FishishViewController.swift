//
//  FishishViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 13/7/24.
//

import UIKit
import Lottie

class FishishViewController: UIViewController {
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var viewSun: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back.layer.cornerRadius = 10
        viewSun.layer.cornerRadius = 10
        showBubbleEffect()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showBubbleEffect() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY)
        emitter.emitterSize = CGSize(width: self.view.bounds.width, height: 1)
        emitter.emitterShape = .line
        
        let bubbleCell = CAEmitterCell()
        bubbleCell.birthRate = 10
        bubbleCell.lifetime = 4.0
        bubbleCell.velocity = 50
        bubbleCell.velocityRange = 10
        bubbleCell.yAcceleration = -50
        bubbleCell.emissionRange = .pi / 4
        bubbleCell.contents = UIImage(named: "heart3")?.cgImage // Hình ảnh bóng bóng
        bubbleCell.scale = 0.1
        bubbleCell.scaleRange = 0.05
        bubbleCell.alphaSpeed = -0.2
        
        emitter.emitterCells = [bubbleCell]
        self.view.layer.addSublayer(emitter)
        
        // Xóa emitter sau 5 giây
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            emitter.removeFromSuperlayer()
        }
    }
    
    
}
