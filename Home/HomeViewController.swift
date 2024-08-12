
import UIKit
import CoreLocation

class HomeViewController: UIViewController, HomeMenuCollectionViewCellDelegate {
    
    
    @IBOutlet weak var customviewHome: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var collec: UICollectionView!
    @IBOutlet weak var home: Home!
    @IBOutlet weak var tabBar: TabBar!
    let location = CLLocationManager()
    var customViewHidden = false
    var newData = [MenuFood]()
    var filteredData = [MenuFood]()
    var isSearching = false
    var allData : [MenuFood] = []
    var Hamburger: [MenuFood] = []
    var Chicken: [MenuFood] = []
    var pizza: [MenuFood] = []
    var rice: [MenuFood] = []
    var selectedCategoryIndex: Int = 0 {
        didSet {
            updateFilteredData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(UINib(nibName: "HomeMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenuCollectionViewCell")
        loadProducts()
        collec.showsHorizontalScrollIndicator = false
        collec.showsVerticalScrollIndicator = false
        home.delegate = self // Đặt HomeSearchDelegate
        customView.isHidden = false
        initialLocation()
        
        
    }
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collec)
        
        switch gesture.state {
        case .began:
            if let indexPath = collec.indexPathForItem(at: location), let cell = collec.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Phóng to 20%
                    cell.alpha = 0.8 // Làm mờ một chút để nhấn mạnh
                })
            }
            
        case .ended, .cancelled:
            if let indexPath = collec.indexPathForItem(at: location), let cell = collec.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = .identity // Trở lại kích thước ban đầu
                    cell.alpha = 1.0 // Trở lại độ mờ ban đầu
                })
            }
            
        default:
            break
        }
    }

    private func initialLocation() {
            location.delegate = self
            
            // Kiểm tra trạng thái quyền hiện tại
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Yêu cầu quyền nếu chưa được xác định
                location.requestAlwaysAuthorization()
            case .restricted, .denied:
                // Xử lý trường hợp dịch vụ vị trí bị hạn chế hoặc bị từ chối
                print("Dịch vụ vị trí bị hạn chế hoặc bị từ chối.")
            case .authorizedAlways, .authorizedWhenInUse:
                // Dịch vụ vị trí đã được cấp phép
                // Bạn có thể bắt đầu nhận cập nhật vị trí
                startLocationUpdates()
            @unknown default:
                // Xử lý các trường hợp không xác định
                print("Trạng thái quyền không xác định.")
            }
        }
    private func startLocationUpdates() {
          if CLLocationManager.locationServicesEnabled() {
              location.startUpdatingLocation()
          } else {
              print("Dịch vụ vị trí không được bật.")
          }
      }
    
//    private func initialLocation() {
//        location.delegate = self
//        guard CLLocationManager.locationServicesEnabled() else {
//            return
//        }
//        location.requestAlwaysAuthorization()
//    }
    
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
                self.allData = newData
                self.Hamburger = self.newData.filter { (menuFood: MenuFood) in menuFood.name == "Hamburger" }
                self.Chicken = self.newData.filter { (menuFood: MenuFood) in menuFood.name == "Chicken" }
                self.pizza = self.newData.filter { (menuFood: MenuFood) in menuFood.name == "Pizza" }
                self.rice = self.newData.filter { (menuFood: MenuFood) in menuFood.name == "Rice" }
                
                DispatchQueue.main.async {
                    self.collec.reloadData()
                    self.updateFilteredData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    private func updateFilteredData() {
        switch selectedCategoryIndex {
        case 0:
            newData = allData
        case 1:
            newData = Hamburger
        case 2:
            newData = Chicken
        case 3:
            newData = pizza
        case 4:
            newData = rice
        default:
            newData = []
        }
        collec.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrollingDown = scrollView.contentOffset.y > 0
        
        if isScrollingDown {
            UIView.animate(withDuration: 0.5, animations: {
                self.customviewHome.alpha = 0
            }) { _ in
                self.customviewHome.isHidden = true
            }
        } else {
            if self.customviewHome.isHidden {
                self.customviewHome.isHidden = false
                UIView.animate(withDuration: 1) {
                    self.customviewHome.alpha = 1
                }
            }
            
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredData.count : newData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuCollectionViewCell", for: indexPath) as! HomeMenuCollectionViewCell
        let data =  isSearching ? filteredData[indexPath.row] : newData[indexPath.row]
        cell.name.text = data.name
        cell.pointStar.text = data.id
        cell.middleName.text = data.callFour
        cell.heart.image = UIImage(named: data.isHearted ?? false ? "heart3": "heart-2")
        if !data.avatar.isEmpty {
            let urlString = "\(data.avatar)"
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    guard let data = data else {
                        print("No image data received")
                        return
                    }
                    DispatchQueue.main.async {
                        cell.ima.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.delegate = tabBar
        cell.delegatess = self
        cell.cellIndexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [], animations: {
            cell.transform = .identity
            cell.alpha = 1
        }, completion: nil)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data =  isSearching ? filteredData[indexPath.row] : newData[indexPath.row]
        let vc = SeclectFoodViewController()
        vc.seclectIma = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: HomeSearchDelegate {
    func didUpdateSearchText(_ searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredData.removeAll()
        } else {
            isSearching = true
            filteredData = newData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collec.reloadData()
    }
    func didSelectCategory(index: Int) {
        selectedCategoryIndex = index
    }
    
    func didTapHeart(on cell: HomeMenuCollectionViewCell) {
        guard let indexPath = cell.cellIndexPath else { return }
        var menuFood = newData[indexPath.row]
        
        if cell.heartChange {
            if menuFood.postID == nil {
                createPost(from: menuFood) { [weak self] result in
                    switch result {
                    case .success(let post):
                        print("Successfully created post: \(post)")
                        DispatchQueue.main.async {
                            menuFood.postID = post.id
                            menuFood.isHearted = true
                            self?.newData[indexPath.row] = menuFood
                        }
                    case .failure(let error):
                        print("Error creating post: \(error)")
                    }
                }
            }
        }
        else {
            if let postID = menuFood.postID {
                deletePost(postID: postID) { [weak self] result in
                    switch result {
                    case .success:
                        print("Successfully deleted post")
                        DispatchQueue.main.async {
                            menuFood.isHearted = false
                            menuFood.postID = nil
                            self?.newData[indexPath.row] = menuFood
                        }
                    case .failure(let error):
                        print("Error deleting post: \(error)")
                    }
                }
            }
        }
    }
    
    private func updateFoodItem(_ foodItem: MenuFood, at indexPath: IndexPath) {
        if isSearching {
            filteredData[indexPath.row] = foodItem
        } else {
            newData[indexPath.row] = foodItem
        }
        collec.reloadItems(at: [indexPath])
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            if (placemarks?.first) != nil {
                let address = "Bac Tu liem, Ha Noi" // Replace with actual address from placemark
                
                DispatchQueue.main.async {
                    self.home.address = address
                    self.home.adress.text = address
                }
            }
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .denied, .restricted:
            print("Location access denied/restricted")
        case .notDetermined:
            print("Location access not determined")
        case .authorizedWhenInUse, .authorizedAlways:
            location.startUpdatingLocation()
        default:
            print("Unknown location authorization status")
        }
    }
}
