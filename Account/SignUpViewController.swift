//
//  SignUpViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 6/7/24.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var againPassword: UITextField!
    @IBOutlet weak var confirm: UIButton!
    private let labelEmail = 55555
    private let originalSizeOfEmail: CGFloat = 8
    private let labelPassword = 55555
    private let originalSizeOfPassword: CGFloat = 8
    private let labelAgainPassword = 55555
    private let originalSizeOfAgainPassword: CGFloat = 8
    var callProfile : (() ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let maskPath = UIBezierPath(roundedRect: navBarView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        navBarView.layer.mask = maskLayer
        email.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        againPassword.layer.cornerRadius = 20
        confirm.layer.cornerRadius = 20
        email.layer.masksToBounds = true
        password.layer.masksToBounds = true
        againPassword.layer.masksToBounds = true
        email.layer.borderWidth = 1
        password.layer.borderWidth = 1
        againPassword.layer.borderWidth = 1
        email.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(didChangeTextOne(_:)), for: .editingChanged)
        againPassword.addTarget(self, action: #selector(didChangeTextTwo(_:)), for: .editingChanged)
        let emailFontSize: CGFloat = 14
        let passwordFontSize: CGFloat = 14
        let AgainpasswordFontSize: CGFloat = 14
        
        
        if let label = email.viewWithTag(labelEmail) as? UILabel {
            label.frame = email.bounds.insetBy(dx: originalSizeOfEmail, dy: 3)
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: emailFontSize) // Sửa kích thước chữ cho nhãn email
        } else {
            let label = UILabel(frame: email.bounds.insetBy(dx: originalSizeOfEmail, dy: 3))
            label.text = "Email"
            label.textColor = .lightGray
            label.tag = labelEmail
            label.font = UIFont.systemFont(ofSize: emailFontSize) // Sửa kích thước chữ cho nhãn email
            email.addSubview(label)
        }
        
        if let label = password.viewWithTag(labelPassword) as? UILabel {
            label.frame = password.bounds.insetBy(dx: originalSizeOfPassword, dy: 3)
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: passwordFontSize) // Sửa kích thước chữ cho nhãn email
        } else {
            let label = UILabel(frame: password.bounds.insetBy(dx: originalSizeOfPassword, dy: 3))
            label.text = "Password"
            label.textColor = .lightGray
            label.tag = labelPassword
            label.font = UIFont.systemFont(ofSize: passwordFontSize) // Sửa kích thước chữ cho nhãn email
            password.addSubview(label)
        }
        
        if let label = againPassword.viewWithTag(labelAgainPassword) as? UILabel {
            label.frame = againPassword.bounds.insetBy(dx: originalSizeOfAgainPassword, dy: 3)
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: AgainpasswordFontSize) // Sửa kích thước chữ cho nhãn email
        } else {
            let label = UILabel(frame: againPassword.bounds.insetBy(dx: originalSizeOfAgainPassword, dy: 3))
            label.text = "AgainPassword"
            label.textColor = .lightGray
            label.tag = labelAgainPassword
            againPassword.addSubview(label)
            label.font = UIFont.systemFont(ofSize: AgainpasswordFontSize) // Sửa kích thước chữ cho nhãn email
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
        guard let label = textField.viewWithTag(labelPassword) as? UILabel else { return }
        
        UIView.animate(withDuration: 0.5) {
            if textField.text?.isEmpty ?? true {
                label.frame.origin.x = self.originalSizeOfPassword
                label.font = UIFont.systemFont(ofSize: 14)
            } else {
                label.frame.origin.x = self.password.bounds.width - label.bounds.width + 165
                label.font = UIFont.systemFont(ofSize: 10)
            }
        }
    }
    
    @objc func didChangeTextTwo(_ textField: UITextField) {
        guard let label = textField.viewWithTag(labelAgainPassword) as? UILabel else { return }
        
        UIView.animate(withDuration: 0.5) {
            if textField.text?.isEmpty ?? true {
                label.frame.origin.x = self.originalSizeOfAgainPassword
                label.font = UIFont.systemFont(ofSize: 14)
            } else {
                label.frame.origin.x = self.againPassword.bounds.width - label.bounds.width + 138
                label.font = UIFont.systemFont(ofSize: 10)
            }
        }
    }
    @IBAction func signUp(_ sender: Any) {
        if email.text == "" || password.text == "" || againPassword.text == "" {
            notification(mess: "User has not entered information")
        }
        if ((email.text?.hasSuffix("@gmail.com")) == false) {
               notification(mess: "Email must be a @gmail.com address")
            return
           }
        else if password.text!.count < 6 {
            notification(mess: "Password is not strong enough")
        }
        else if password.text != againPassword.text {
            notification(mess: "Passwords are not the same")
        }
        
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                notification(mess: "Registration successful")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigationController?.popViewController(animated: true)
                }
                clearProfileData()
                saveUserCredentials()
                if error != nil {
                    
//                    self.notification(mess: "\(error!.localizedDescription)")
                }
                else {
                   
                }
            }
            
        }
        
         func saveUserCredentials() {
              let defaults = UserDefaults.standard
              defaults.set(email.text, forKey: "userEmail")
              defaults.set(password.text, forKey: "userPassword")
          }
          
        // Phương thức để xóa thông tin hồ sơ
         func clearProfileData() {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "name")
            defaults.removeObject(forKey: "address")
            defaults.removeObject(forKey: "profileImage")
        }


        func  notification(mess: String) {
            let Alert:UIAlertController = UIAlertController(title: "Notification", message: mess, preferredStyle: UIAlertController.Style.alert)
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
}
