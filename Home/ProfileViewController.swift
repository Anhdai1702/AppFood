

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var hitoryFood: UIButton!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var out: UIButton!
    @IBOutlet weak var people: UIImageView!
    @IBOutlet weak var display: UIImageView!
    @IBOutlet weak var viewSon: UIView!
    @IBOutlet weak var pandemic: UIButton!
    
    var onEyes = false
    var displayoff = false
    override func viewDidLoad() {
        let maskPath = UIBezierPath(roundedRect: viewSon.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        viewSon.layer.mask = maskLayer
        email.layer.cornerRadius = 10
        name.layer.cornerRadius = 10
        address.layer.cornerRadius = 10
        pass.layer.cornerRadius = 10
        email.layer.borderWidth = 1
        name.layer.borderWidth = 1
        address.layer.borderWidth = 1
        pass.layer.borderWidth = 1
        email.layer.masksToBounds = true
        name.layer.masksToBounds = true
        address.layer.masksToBounds = true
        pass.layer.masksToBounds = true
        editProfile.layer.cornerRadius = 10
        out.layer.cornerRadius = 10 
        out.layer.borderColor = UIColor.red.cgColor
        out.layer.borderWidth = 1
        people.layer.cornerRadius = 10
        people.layer.masksToBounds = true
        email.isUserInteractionEnabled = false
        name.isUserInteractionEnabled = false
        address.isUserInteractionEnabled = false
        pass.isUserInteractionEnabled = false
        loadProfileData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // Tải lại dữ liệu hồ sơ mỗi khi ProfileViewController hiển thị
          loadProfileData()
      }
    
    func tapImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        people.isUserInteractionEnabled = true
        people.addGestureRecognizer(tap)
      
    }
    
    @objc func imageTap() {
        let imageTap = UIImagePickerController()
        imageTap.sourceType = .photoLibrary
        imageTap.delegate = self
        self.present(imageTap, animated: true, completion: nil)
      
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        clearUserCredentials()
        _ = LoginViewController()
        // Tìm HomeViewController trong navigation stack
           if let viewControllers = self.navigationController?.viewControllers {
               for viewController in viewControllers {
                   if let homeViewController = viewController as? LoginViewController {
                       self.navigationController?.popToViewController(homeViewController, animated: true)
                       return
                   }
               }
           }
        
    }
    
    @IBAction func display(_ sender: Any) {
       
        guard displayoff else { return }
        self.onEyes = !self.onEyes
        if onEyes {
            pass.isSecureTextEntry = true
            display.image = UIImage(named: "view")
        }
        else {
            pass.isSecureTextEntry = false
            display.image = UIImage(named: "hidden")
        }
       
    }
    
    @IBAction func edit(_ sender: Any) {
        displayoff = true
        tapImage()
        email.isUserInteractionEnabled = true
        name.isUserInteractionEnabled = true
        address.isUserInteractionEnabled = true
        pass.isUserInteractionEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.pandemic.setTitle("Lưu", for: .normal)
        }
        pandemic.isHidden = false
        
    }
    
        func saveProfileData() {
            let defaults = UserDefaults.standard
            defaults.set(name.text, forKey: "name")
            defaults.set(email.text, forKey: "email")
            defaults.set(address.text, forKey: "address")
            defaults.set(pass.text, forKey: "pass")
           
            if let imageData = people.image?.pngData() {
                       defaults.set(imageData, forKey: "profileImage")
                   }
        }
        
    func loadProfileData() {
           let defaults = UserDefaults.standard
           name.text = defaults.string(forKey: "name")
           email.text = defaults.string(forKey: "userEmail") // Tải email
           address.text = defaults.string(forKey: "address")
           pass.text = defaults.string(forKey: "userPassword") // Tải mật khẩu
           
           if let imageData = defaults.data(forKey: "profileImage"), let image = UIImage(data: imageData) {
               people.image = image
           } else {
               people.image = UIImage(named: "people 1") // Hình ảnh mặc định
           }
       }
    @IBAction func pandemic(_ sender: Any) {
        if self.pandemic.title(for: .normal) == "Lưu" {
            let newPassword = pass.text ?? ""
            // Loại bỏ gesture recognizer cho ảnh
            self.people.isUserInteractionEnabled = false
            if let gestureRecognizers = self.people.gestureRecognizers {
                for gesture in gestureRecognizers {
                    self.people.removeGestureRecognizer(gesture)
                }
            }
            updatePassword(newPassword: newPassword) { [weak self] success in
                guard let self = self else { return }
                updatePassword(newPassword: newPassword) { [weak self] success in
                    guard let self = self else { return }
                if success {
                    self.email.isUserInteractionEnabled = false
                    self.name.isUserInteractionEnabled = false
                    self.address.isUserInteractionEnabled = false
                    self.pass.isUserInteractionEnabled = false
                    self.saveProfileData()
                    }
                    else {
                        // Hiển thị thông báo lỗi nếu cập nhật mật khẩu thất bại
                        print("1")
                    }
                    pandemic.isHidden = true
                    displayoff = false
                }
            }
        }
    }
        

    private func clearUserCredentials() {
//           let defaults = UserDefaults.standard
//           defaults.removeObject(forKey: "name")
//           defaults.removeObject(forKey: "address")
//           defaults.removeObject(forKey: "profileImage")
       }
    private func updatePassword(newPassword: String, completion: @escaping (Bool) -> Void) {
            let user = Auth.auth().currentUser
            
            user?.updatePassword(to: newPassword) { error in
                if let error = error {
                    print("Failed to update password: \(error.localizedDescription)")
                    completion(false)
                } else {
                    let defaults = UserDefaults.standard
                                   defaults.set(newPassword, forKey: "userPassword")
                    completion(true)
                }
            }
        }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        people.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
