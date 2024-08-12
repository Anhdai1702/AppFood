

import UIKit

let arr = [Title(name: "", ima: "chicken")]
let arrOne = [Title(name: "", ima: "")]
let arrTwo = [Title(name: "", ima: "")]
let arrThree = [Title(name: "", ima: "")]
let arrFour = [Title(name: "", ima: "")]

let titleArr = TitleName(tỉtleSection: "All", tilteIma: "allFood", titleNameSection: arr)
let titleArrOne = TitleName(tỉtleSection: "Hamburger", tilteIma: "burger", titleNameSection: arrOne)
let titleArrTwo = TitleName(tỉtleSection: "Chicken", tilteIma: "chicken", titleNameSection: arrTwo)
let titleArrThree = TitleName(tỉtleSection: "Pizza", tilteIma: "pizza", titleNameSection: arrThree)
let titleArrFour = TitleName(tỉtleSection: "Rice", tilteIma: "rice", titleNameSection: arrFour)

let listArr: [TitleName] = [titleArr, titleArrOne, titleArrTwo, titleArrThree, titleArrFour]
var list : [Title] = []

protocol HomeSearchDelegate: AnyObject {
    func didUpdateSearchText(_ searchText: String)
    func didSelectCategory(index: Int)
}

class Home: UIView {
    var index = 0
    weak var delegate: HomeSearchDelegate?
    @IBOutlet var home: UIView!
    @IBOutlet weak var adress: UILabel!
    var address : String?
//        didSet {
//            if adress.text == "" {
//                adress.isHidden = true
//            }
//            else {
//                // Cập nhật giá trị của adress khi address thay đổi
//                adress.text = address
//                adress.isHidden = false
//            }
//        }
//    }
//    
    var textSreach = 55555
    var originalSizeOfSreach: CGFloat = 8
    @IBOutlet weak var collec: UICollectionView!
    @IBOutlet weak var sreach: UITextField!
    var textField = [String]()
    var sreaching = false
    var filteredFood: [DataFood] = []
    var allData: [DataFood] = [] // Dữ liệu gốc
    var isSearching = false
    var newData : [MenuFood] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = "Home"
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        sreach.delegate = self // Đặt delegate
    }
//    func startMovingAnimation() {
//            let animation = CABasicAnimation(keyPath: "position.x")
//            animation.fromValue = collec.layer.position.x
//            animation.toValue = collec.layer.position.x + 100 // Di chuyển 100 điểm
//            animation.duration = 2.0
//            animation.autoreverses = true
//            animation.repeatCount = .infinity
//            collec.layer.add(animation, forKey: "move")
//        }
    func startBouncyAnimation() {
           let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
           bounceAnimation.values = [1.0, 1.2, 0.9, 1.1, 1.0]
           bounceAnimation.keyTimes = [0, 0.5, 0.7, 0.9, 1]
           bounceAnimation.duration = 1.0
           bounceAnimation.repeatCount = .infinity
           collec.layer.add(bounceAnimation, forKey: "bounce")
       }

   

    override func layoutSubviews() {
        sreach.layer.cornerRadius = 20
        sreach.layer.masksToBounds = true
        sreach.layer.borderWidth = 1
        sreach.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        if let label = sreach.viewWithTag(textSreach) as? UILabel {
            label.frame = sreach.bounds.insetBy(dx: originalSizeOfSreach, dy: 3)
            label.textColor = .lightGray
        } else {
            let label = UILabel(frame: sreach.bounds.insetBy(dx: originalSizeOfSreach, dy: 3))
            label.text = "Sreach"
            label.textColor = .lightGray
            label.tag = textSreach
            sreach.addSubview(label)
        }
        collec.delegate = self
        collec.dataSource = self
        collec.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        collec.showsHorizontalScrollIndicator = false
        collec.showsVerticalScrollIndicator = false
        loadProducts()
        if address == "" {
            adress.isHidden = true
        } else {
            adress.text = address
        }
    }
    
    @objc func didChangeText(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        guard let label = textField.viewWithTag(textSreach) as? UILabel else { return }
        
        UIView.animate(withDuration: 0.5) {
            if searchText.isEmpty {
                label.frame.origin.y = 3
                label.font = UIFont.systemFont(ofSize: 14)
                self.isSearching = false
            } else {
                label.frame.origin.y = self.sreach.bounds.height - label.bounds.height - 15
                label.font = UIFont.systemFont(ofSize: 10)
                self.isSearching = true
            }
        }
        
        delegate?.didUpdateSearchText(searchText)
    }
//    func startAnimation() {
//            let animation = CABasicAnimation(keyPath: "position.y")
//            animation.fromValue = self.layer.position.y
//            animation.toValue = self.layer.position.y + 50
//            animation.duration = 1.0
//            animation.autoreverses = true
//            animation.repeatCount = .infinity
//            self.layer.add(animation, forKey: "bounce")
//        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.home.alpha = 0
            }) { _ in
                self.home.isHidden = true
            }
        } else {
            if self.home.isHidden {
                self.home.isHidden = false
                UIView.animate(withDuration: 1) {
                    self.home.alpha = 1
                }
            }
        }
    }
    
}

extension Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let data = listArr[indexPath.row]
        cell.title.text = data.tỉtleSection
        cell.ima.image = UIImage(named: data.tilteIma)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory(index: indexPath.row)
    }   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [], animations: {
            cell.transform = .identity
            cell.alpha = 1
        }, completion: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        delegate?.didUpdateSearchText(updatedText)
        return true
    }
    private func loadProducts() {
        let url = URL(string: "https://6684122e56e7503d1adf3ba7.mockapi.io/callApi")!
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                self.newData = try JSONDecoder().decode([MenuFood].self, from: data)
                
                DispatchQueue.main.async {
                    self.collec.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}

