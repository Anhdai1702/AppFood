//
//  CustomView.swift
//  AppFood
//
//  Created by Phùng Anh Đài  on 7/8/24.
//

    import UIKit



    class CustomView: UIView {
        let arr = ["foster", "foster1", "foster2", "foster3"]
        var index = 0
        @IBOutlet var view: UIView!
        @IBOutlet weak var collec: UICollectionView!
        
        @IBOutlet weak var ima: UIImageView!
        override init(frame: CGRect) {
              super.init(frame: frame)
              setupView()
        }
        
        override func layoutSubviews() {
        super.layoutSubviews()
            
      }
        
        @objc func setupCollec() {
                if index < arr.count - 1 {
                    index += 1
                } else {
                    index = 0
                }
                collec.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
            }

          
          required init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              setupView()
          }
          
          private func loadViewFromNib() -> UIView? {
              let nibName = "CustomView"
              let bundle = Bundle(for: type(of: self))
              let nib = UINib(nibName: nibName, bundle: bundle)
              return nib.instantiate(withOwner: self, options: nil).first as? UIView
          }
          
          private func setupView() {
              guard let view = loadViewFromNib() else { return }
              view.frame = bounds
              view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              addSubview(view)
              collec.dataSource = self
              collec.delegate = self
              collec.register(UINib(nibName: "CustomViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomViewCollectionViewCell")
              Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupCollec), userInfo: nil, repeats: true)
              collec.showsHorizontalScrollIndicator = false
              collec.showsVerticalScrollIndicator = false
          }

    }
    extension CustomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arr.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomViewCollectionViewCell", for: indexPath) as! CustomViewCollectionViewCell
//            let data = arr[indexPath.row]
            cell.ima.image = UIImage(named: arr[indexPath.row])
            cell.pageControl.currentPage = indexPath.row
            cell.pageControl.numberOfPages = arr.count
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 370, height: 250)
        }
    }
