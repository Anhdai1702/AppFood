//
//  ScreenSaverViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 28/7/24.
//

import UIKit

class ScreenSaverViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let customTransitionAnimator = CustomTransitionAnimator()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
        setGradientBackground()
        letvc()
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
    func letvc() {
        let detailViewController = LoginViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType(rawValue: "oglFlip")


            transition.subtype = .fromRight // Thay đổi hướng tùy ý


            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          return customTransitionAnimator
      }
      
      func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          return customTransitionAnimator
      }
    

    
}
