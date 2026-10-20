//
//  ContentCollectionViewCell.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var posterImgView: UIImageView!
    
    @IBOutlet weak var titlelbl: UILabel!
    
    func configure(with content: Content) {
        titlelbl.text = content.title

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: content.thumbnailURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImgView.image = image
                }
            }
        }
    }
}
