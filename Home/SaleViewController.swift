//
//  SaleViewController.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 31/7/24.
//

import UIKit
 
class SaleViewController: UIViewController {
    var blurEffectView: UIVisualEffectView?
    var highlightedCell: UITableViewCell?
    @IBOutlet weak var table: UITableView!
    var newData : [MenuFood] = []
    @IBOutlet weak var panControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Xóa bất kỳ lớp nào đã thêm trước đó để tránh việc lớp bị thêm nhiều lần
//        table.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "CustomViewTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomViewTableViewCell")
        table.estimatedSectionHeaderHeight = 50 // Thiết lập chiều cao ước lượng cho header
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        table.reloadData()
        loadProducts()
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                table.addGestureRecognizer(longPressGesture)
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: table)
        guard let indexPath = table.indexPathForRow(at: location),
              let cell = table.cellForRow(at: indexPath) else { return }
        
        switch gesture.state {
        case .began:
            blurTableView(except: cell)
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            highlightedCell = cell
        case .ended, .cancelled:
            removeBlurEffect()
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform.identity
            }
            highlightedCell = nil
        default:
            break
        }
    }

       
    func blurTableView(except cell: UITableViewCell) {
        // Remove existing blur effect view if any
        blurEffectView?.removeFromSuperview()
        
        // Create and add blur effect view
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // Ensure the blurEffectView covers the entire table view's superview
        if let superview = table.superview {
            blurEffectView?.frame = superview.bounds
            superview.addSubview(blurEffectView!)
            
            // Create a path to exclude the cell being highlighted
            let path = UIBezierPath(rect: superview.bounds)
            let cellFrameInSuperview = cell.convert(cell.bounds, to: superview)
            let cellPath = UIBezierPath(rect: cellFrameInSuperview)
            path.append(cellPath)
            path.usesEvenOddFillRule = true
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillRule = .evenOdd
            
            blurEffectView?.layer.mask = maskLayer
        }
    }

    func removeBlurEffect() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }

       
    func loadProducts() {
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
                        self.table.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

}

extension SaleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomViewTableViewCell", for: indexPath) as! CustomViewTableViewCell
        let data = newData[indexPath.row]
        cell.name.text = data.name
        cell.midName.text = data.callFour
        cell.pointStar.text = data.id
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
        let separatorLine = CALayer()
             separatorLine.backgroundColor = UIColor.black.cgColor // Thay đổi màu của vạch kẻ tại đây
             separatorLine.frame = CGRect(x: 0, y: cell.contentView.frame.height - 1, width: cell.contentView.frame.width, height: 2) // Chiều cao vạch kẻ là 1px
             cell.contentView.layer.addSublayer(separatorLine)
        let topSeparator = CALayer()
               topSeparator.backgroundColor = UIColor.black.cgColor // Thay đổi màu của vạch kẻ trên tại đây
               topSeparator.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 1) // Chiều cao vạch kẻ là 1px
               cell.contentView.layer.addSublayer(topSeparator)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           // Cập nhật vị trí của lớp làm mờ khi cuộn
           if let blurEffectView = blurEffectView {
               blurEffectView.frame = table.superview?.bounds ?? table.bounds
           }
       }
       

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = CustomView()
        return customView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 1
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
           cell.alpha = 0
           UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [], animations: {
               cell.transform = .identity
               cell.alpha = 1
           }, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = newData[indexPath.row]
        let newArr = MenuFood(avatar: arr.avatar, name: arr.name, id: arr.id, intro: arr.intro, price: arr.price, call: arr.call, callThree: arr.callThree, callFour: arr.callFour)
        let vc = SeclectFoodViewController()
        vc.seclectIma = newArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
