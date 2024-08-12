//
//  TabBar.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 8/7/24.
//

import UIKit



class TabBar: UIView, HeartChangeDelegate {
    
    
    @IBOutlet weak var slHeat: UILabel!
    var totalHeartCount = 0
    var totalHeartCountMinus = 0
    @IBOutlet var view: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        slHeat.isHidden = true
    }
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
        let nibName = "TabBar" // Tên của file XIB (không cần phần mở rộng .xib)
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
    
    
    @IBAction func home(_ sender: Any) {
        pushToViewController(HomeViewController.self)
    }
    @IBAction func user(_ sender: Any) {
        pushToViewController(ProfileViewController.self)
    }
    
    @IBAction func mess(_ sender: Any) {
        pushToViewController(SaleViewController.self)

    }
    
    @IBAction func heart(_ sender: Any) {
        pushToViewController(HeartViewController.self)
    }
    
    private func pushToViewController(_ viewControllerType: UIViewController.Type) {
    var search: UIResponder? = self
    while search != nil {
        if let viewController = search as? UIViewController {
            if let navigationController = viewController.navigationController {
                let newViewController = viewControllerType.init()
                navigationController.pushViewController(newViewController, animated: true)
                return
            }
        }
        search = search?.next
    }
}
    
    func heartCountDidChange(newCount: Int) {
        totalHeartCount += newCount
        slHeat.text = "\(totalHeartCount)"
        slHeat.isHidden = false
        if totalHeartCount == 0 {
            slHeat.isHidden = true
        }
    }
}
