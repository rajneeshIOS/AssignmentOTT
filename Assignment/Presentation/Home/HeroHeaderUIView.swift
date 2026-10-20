//
//  HeroHeaderUIView.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    var onViewDetailsTapped: (() -> Void)?
    
    @IBOutlet weak var heroImgView: UIImageView!
    @IBOutlet weak var detailbtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromXib()
    }
    func loadViewFromXib() {
        let view = Bundle.main.loadNibNamed(
            "HeroHeaderUIView",
            owner: self,
            options: nil
        )?.first as! UIView
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        titleLbl.textColor = .white
        descriptionLbl.textColor = .white

        titleLbl.numberOfLines = 0
        descriptionLbl.numberOfLines = 0

        detailbtn.setTitle("View Details", for: .normal)
        detailbtn.backgroundColor = .systemRed
        detailbtn.setTitleColor(.white, for: .normal)
        detailbtn.layer.cornerRadius = 10
        detailbtn.clipsToBounds = true
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func viewDetailBtnTapped(_ sender: Any) {
        onViewDetailsTapped?()
    }
    
}
