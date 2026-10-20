//
//  ContentDetailViewController.swift
//  Assignment
//
//  Created by Rajneesh Singh on 20/10/26.
//

import UIKit
import AVKit

class ContentDetailViewController: UIViewController {
    
     let content: Content

        let thumbnailImageView = UIImageView()
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let playButton = UIButton(type: .system)

       init(content: Content) {
           self.content = content
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError("Use init(content:) instead")
       }

       override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = .white
           title = "Content Details"

           setupUI()
           loadThumbnail()
       }

       private func setupUI() {
           thumbnailImageView.contentMode = .scaleAspectFit
           thumbnailImageView.backgroundColor = .darkGray

           titleLabel.text = content.title
           titleLabel.textColor = .black
           titleLabel.font = .boldSystemFont(ofSize: 24)
           titleLabel.numberOfLines = 0

           descriptionLabel.text = content.description
           descriptionLabel.textColor = .lightGray
           descriptionLabel.font = .systemFont(ofSize: 16)
           descriptionLabel.numberOfLines = 0

           playButton.setTitle("Play", for: .normal)
           playButton.setTitleColor(.white, for: .normal)
           playButton.backgroundColor = .systemRed
           playButton.layer.cornerRadius = 8
           playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
           

           let stackView = UIStackView(arrangedSubviews: [
               thumbnailImageView,
               titleLabel,
               descriptionLabel,
               playButton
           ])

           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.translatesAutoresizingMaskIntoConstraints = false

           view.addSubview(stackView)

           thumbnailImageView.heightAnchor.constraint(
               equalToConstant: 240
           ).isActive = true

           playButton.heightAnchor.constraint(
               equalToConstant: 50
           ).isActive = true

           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(
                   equalTo: view.safeAreaLayoutGuide.topAnchor,
                   constant: 20
               ),
               stackView.leadingAnchor.constraint(
                   equalTo: view.leadingAnchor,
                   constant: 20
               ),
               stackView.trailingAnchor.constraint(
                   equalTo: view.trailingAnchor,
                   constant: -20
               )
           ])
       }

        func loadThumbnail() {
           URLSession.shared.dataTask(with: content.thumbnailURL) {
               [weak self] data, response, error in

               guard let data = data,
                     let image = UIImage(data: data) else { return }

               DispatchQueue.main.async {
                   self?.thumbnailImageView.image = image
               }
           }.resume()
       }

       @objc private func playVideo() {
           let player = AVPlayer(url: content.videoURL)

           let playerVC = CustomVideoPlayerViewController()
           playerVC.player = player
           playerVC.modalPresentationStyle = .fullScreen

           present(playerVC, animated: true) {
               player.play()
           }
       }
}
