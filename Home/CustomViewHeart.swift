

import UIKit


class CustomViewHeart: UIView {
    
    var callBack : (()-> Void)?
    
    let new : [Post] = []
    @IBOutlet weak var pice: UILabel!
    @IBOutlet weak var namPrice: UILabel!
    @IBOutlet weak var order: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = "CustomViewHeart"
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    override func layoutSubviews() {
        order.layer.cornerRadius = 10
    }
    
    func updateTotalPrice(_ total: Float) {
            pice.text = "\(total)$"
        }
    
    @IBAction func order(_ sender: Any) {
        self.callBack?()
    }
}
