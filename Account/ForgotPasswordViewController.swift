//
//  ForgotPasswordViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 6/7/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var navbarVỉew: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var confim: UIButton!
    private let labelEmail = 55555
    private let originalSizeOfEmail: CGFloat = 8
    private let labelCode = 55555
    private let originalSizeOfCode: CGFloat = 8
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let maskPath = UIBezierPath(roundedRect: navbarVỉew.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        navbarVỉew.layer.mask = maskLayer
        email.layer.cornerRadius = 20
        code.layer.cornerRadius = 20
        email.layer.borderWidth = 1
        code.layer.borderWidth = 1
        email.layer.masksToBounds = true
        code.layer.masksToBounds = true
        confim.layer.cornerRadius = 20
        confim.layer.borderWidth = 1
        email.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        code.addTarget(self, action: #selector(didChangeTextOne(_:)), for: .editingChanged)
        if let label = email.viewWithTag(labelEmail) as? UILabel {
            label.frame = email.bounds.insetBy(dx: originalSizeOfEmail, dy: 3)
            label.textColor = .lightGray
        } else {
            let label = UILabel(frame: email.bounds.insetBy(dx: originalSizeOfEmail, dy: 3))
            label.text = "Email"
            label.textColor = .lightGray
            label.tag = labelEmail
            email.addSubview(label)
        }
        
        if let label = code.viewWithTag(labelCode) as? UILabel {
            label.frame = code.bounds.insetBy(dx: originalSizeOfCode, dy: 3)
            label.textColor = .lightGray
        } else {
            let label = UILabel(frame: code.bounds.insetBy(dx: originalSizeOfCode, dy: 3))
            label.text = "Code"
            label.textColor = .lightGray
            label.tag = labelCode
            code.addSubview(label)
        }
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
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didChangeText(_ textField: UITextField) {
        guard let label = textField.viewWithTag(labelEmail) as? UILabel else { return }
        
        UIView.animate(withDuration: 0.5) {
            if textField.text?.isEmpty ?? true {
                label.frame.origin.x = self.originalSizeOfEmail
                label.font = UIFont.systemFont(ofSize: 14)
            } else {
                label.frame.origin.x = self.email.bounds.width - label.bounds.width + 185
                label.font = UIFont.systemFont(ofSize: 10)
            }
        }
    }
    
    @objc func didChangeTextOne(_ textField: UITextField) {
        guard let label = textField.viewWithTag(labelCode) as? UILabel else { return }
        
        UIView.animate(withDuration: 0.5) {
            if textField.text?.isEmpty ?? true {
                label.frame.origin.x = self.originalSizeOfCode
                label.font = UIFont.systemFont(ofSize: 14)
            } else {
                label.frame.origin.x = self.code.bounds.width - label.bounds.width + 185
                label.font = UIFont.systemFont(ofSize: 10)
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        if email.text == "" || code.text == "" {
            callCode(mess: "bạn chưa nhập đầy đủ thông tin")
        }
        else {
            let vc = newPassViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func onCode(_ sender: Any) {
        callCode(mess: "Mã xác nhận là: 11111")
    }
    
    
    
    func callCode(mess: String) {
        let Alert:UIAlertController = UIAlertController(title: "", message: mess, preferredStyle: UIAlertController.Style.alert)
        present(Alert, animated:true, completion: nil)
        // Tạo attributed string cho thông điệp với kích thước lớn hơn
        let attributedMessage = NSAttributedString(string: mess, attributes: [
            .font: UIFont.systemFont(ofSize: 17), // Kích thước chữ lớn hơn cho thông điệp
            .foregroundColor: UIColor.black // Màu chữ cho thông điệp
        ])
        Alert.setValue(attributedMessage, forKey: "attributedMessage")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Alert.dismiss(animated: true)
        }
    }
    
}
