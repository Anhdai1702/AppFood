//
//  Login.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 6/7/24.
//

import UIKit
import Firebase

class Login: UIView, UIViewControllerTransitioningDelegate {
    let customTransitionAnimator = CustomTransitionAnimator()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    private let labelEmail = 1
    private let originalSizeOfEmail: CGFloat = 8
    private let labelPassword = 1
    private let originalSizeOfPassword: CGFloat = 8
    // Khai báo init để gọi hàm loadViewFromNib khi khởi tạo từ code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Khai báo init để gọi hàm loadViewFromNib khi khởi tạo từ Interface Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = "Login" // Tên của file XIB (không cần phần mở rộng .xib)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    // Hàm setupView để gọi hàm loadViewFromNib và thêm nó vào custom view
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let emailFontSize: CGFloat = 14
        let passwordFontSize: CGFloat = 14
        email.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        login.layer.cornerRadius = 20
        email.layer.borderWidth = 1
        password.layer.borderWidth = 1
        login.layer.borderWidth = 1
        email.layer.masksToBounds = true
        password.layer.masksToBounds = true
        login.layer.masksToBounds = true
        email.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(didChangeTextOne(_:)), for: .editingChanged)
        
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

          // Thiết lập nhãn cho password text field
          if let label = password.viewWithTag(labelPassword) as? UILabel {
              label.frame = password.bounds.insetBy(dx: originalSizeOfPassword, dy: 3)
              label.textColor = .lightGray
              label.font = UIFont.systemFont(ofSize: passwordFontSize) // Sửa kích thước chữ cho nhãn password
          } else {
              let label = UILabel(frame: password.bounds.insetBy(dx: originalSizeOfPassword, dy: 3))
              label.text = "Password"
              label.textColor = .lightGray
              label.tag = labelPassword
              label.font = UIFont.systemFont(ofSize: passwordFontSize) // Sửa kích thước chữ cho nhãn password
              password.addSubview(label)
          }
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
    
    @IBAction func forgotPass(_ sender: Any) {
        let vc = ForgotPasswordViewController()
        var sreach: UIResponder? = self
        while sreach != nil {
            if let viewController = sreach as? UIViewController {
                if let navigationController = viewController.navigationController {
                    navigationController.pushViewController(vc, animated: true)
                    return
                }
            }
            sreach = sreach?.next
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        if email.text == "" || password.text == "" {
           callCode(mess: "User has not entered information")
        }
        else {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { authResult, error in
                if let error = error as NSError? {
                               let errorCode = AuthErrorCode(rawValue: error.code)
                               
                               switch errorCode {
                               case .invalidEmail:
                                   self.callCode(mess: "Invalid email")
                               default:
                                   self.callCode(mess: "Wrong email or password")
                               }
                           }
                else{
                    let vc = HomeViewController()
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = CATransitionType(rawValue: "oglFlip")


                    transition.subtype = .fromBottom // Thay đổi hướng tùy ý
                    var sreach: UIResponder? = self
                    while sreach != nil {
                        if let viewController = sreach as? UIViewController {
                            if let navigationController = viewController.navigationController {
                                navigationController.pushViewController(vc, animated: true)
                                navigationController.view.layer.add(transition, forKey: kCATransition)
                                return
                            }
                        }
                        sreach = sreach?.next
                    }
                }
            }
        }

    }
    
    
    @IBAction func sginUp(_ sender: Any) {
        let vc = SignUpViewController()
        var sreach: UIResponder? = self
        while sreach != nil {
            if let viewController = sreach as? UIViewController {
                if let navigationController = viewController.navigationController {
                    navigationController.pushViewController(vc, animated: true)
                    return
                }
            }
            sreach = sreach?.next
        }
    }
    
    func callCode(mess: String) {
        let alert = UIAlertController(title: "Notification", message: mess, preferredStyle: .alert)
        
        // Tạo attributed string cho thông điệp với kích thước lớn hơn
        let attributedMessage = NSAttributedString(string: mess, attributes: [
            .font: UIFont.systemFont(ofSize: 17), // Kích thước chữ lớn hơn cho thông điệp
            .foregroundColor: UIColor.black // Màu chữ cho thông điệp
        ])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Tìm UIViewController hiện tại
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                viewController.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alert.dismiss(animated: true)
                }
                return
            }
            responder = responder?.next
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          return customTransitionAnimator
      }
      
      func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          return customTransitionAnimator
      }
    
    
}
