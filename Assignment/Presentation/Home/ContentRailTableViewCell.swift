//
//  ContentRailTableViewCell.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import UIKit

class ContentRailTableViewCell: UITableViewCell {
    var contents: [Content] = []
    var onContentSelected: ((Content) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        contentView.backgroundColor = .black
        backgroundColor = .black

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 220, height: 150)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "ContentCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ContentRailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  contents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCollectionViewCell
        let content = contents[indexPath.item]
            cell.titlelbl.text = content.title

        cell.posterImgView.image = nil

            let imageURL = content.thumbnailURL

            URLSession.shared.dataTask(with: imageURL) { [weak cell] data, _, error in
                guard error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                    return
                }

                DispatchQueue.main.async {
                    guard cell != nil else { return }
                    cell?.posterImgView.image = image
                }
            }.resume()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onContentSelected?(contents[indexPath.item])
    }
}
