//
//  newPassViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 7/7/24.
//

import UIKit

class newPassViewController: UIViewController {
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newPassAgain: UITextField!
    @IBOutlet weak var confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        let maskPath = UIBezierPath(roundedRect: navBarView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        navBarView.layer.mask = maskLayer
        newPass.layer.cornerRadius = 20
        newPassAgain.layer.cornerRadius = 20
        newPass.layer.masksToBounds = true
        newPassAgain.layer.masksToBounds = true
        newPass.layer.borderWidth = 1
        newPassAgain.layer.borderWidth = 1
        confirm.layer.cornerRadius = 20
        confirm.layer.borderWidth = 1
        
        
    }
    
    func setGradientBackground() {
        
        let colorTop = UIColor.red.cgColor
        let colorBottom = UIColor.white.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
