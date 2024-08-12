//
//  HeartViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 13/7/24.
//

import UIKit

class HeartViewController: UIViewController {
    @IBOutlet weak var tableHeart: UITableView!
    @IBOutlet weak var emptyList: UILabel!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var customHeart: CustomViewHeart!
    
    var likedItems: [Post] = []
    var totalAmount: Float = 0.0 {
        didSet {
            customHeart.updateTotalPrice(totalAmount)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyList.text = "Empty list"
        tableHeart.dataSource = self
        tableHeart.delegate = self
        tableHeart.register(UINib(nibName: "HeartTableViewCell", bundle: nil), forCellReuseIdentifier: "HeartTableViewCell")
        tableHeart.reloadData() // Tải dữ liệu khi view được tải
        tableHeart.layer.cornerRadius = 20
        tableHeart.layer.masksToBounds = true
        tableHeart.showsVerticalScrollIndicator = false
        fetchDataFromAPI()
        customHeart.callBack = { [weak self] in
            guard let self = self else { return }
            let vc = PayViewController()
            vc.newData = self.customHeart.pice.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewDidScrollTwo(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.customView.alpha = 0
            }) { _ in
                self.customView.isHidden = true
            }
        } else {
            if self.customView.isHidden {
                self.customView.isHidden = false
                UIView.animate(withDuration: 1) {
                    self.customView.alpha = 1
                }
            }
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLikedItems(_ items: [Post]) {
        likedItems = items
        tableHeart?.reloadData()
        updateTotalAmount()
    }
    
    func fetchDataFromAPI() {
        let url = URL(string: "https://6684122e56e7503d1adf3ba7.mockapi.io/postApi")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let fetchedItems = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self.likedItems = fetchedItems
                    self.tableHeart.reloadData()
                    self.updateTotalAmount()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        .resume()
    }
    
    func updateTotalAmount() {
        totalAmount = likedItems.reduce(0) { result, post in
            let basePrice = Float(post.price ?? "0") ?? 0
            return result + basePrice
        }
        print("New total amount: \(totalAmount)")
        customHeart.updateTotalPrice(totalAmount)
    }
}


extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartTableViewCell", for: indexPath) as! HeartTableViewCell
        let post = likedItems[indexPath.row]
        cell.nameHeart.text = post.name
        cell.midName.text = post.callFour
        cell.initialPrice = post
        cell.onPriceChange = { [weak self] newPrice in
            guard let self = self else { return }
            // Cập nhật giá trị post.price bằng newPrice
            self.likedItems[indexPath.row].price = "\(newPrice)"
            self.updateTotalAmount()
        }
        
        if let imageUrl = URL(string: post.avatar) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("No image data received")
                    return
                }
                DispatchQueue.main.async {
                    cell.imaHeart.image = UIImage(data: data)
                }
            }.resume()
        }
        emptyList.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SeclectFoodViewController()
        let selectedPost = likedItems[indexPath.row]
        let selectedMenuFood = MenuFood(avatar: selectedPost.avatar, name: selectedPost.name, id: selectedPost.id, intro: selectedPost.intro, price: selectedPost.price, call: selectedPost.call, callOne: selectedPost.callOne, callTwo: selectedPost.callTwo, callThree: "", callFour: selectedPost.callFour)
        vc.seclectIma = selectedMenuFood
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}


