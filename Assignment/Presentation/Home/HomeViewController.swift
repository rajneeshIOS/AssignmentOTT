//
//  HomeViewController.swift
//  Assignment
//
//  Created by Rajneesh Singh on 19/10/26.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
     let loadingIndicator = UIActivityIndicatorView(style: .large)
     let viewModel: HomeViewModel

     let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(UINib(nibName: "ContentRailTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "ContentRailTableViewCell")
        
        return table
    }()

    let heroView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: 0, height: 360))
     let sectionTitles = [
        "Trending Now",
        "Recommended for You"
    ]

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) to create HomeViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .white

        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            loadingIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])

        loadingIndicator.startAnimating()
        
        configureNavigationBar()
        bindViewModel()

        viewModel.fetchHomeContent()
    }
     func setupUI() {
        view.backgroundColor = .black

        view.addSubview(homeFeedTable)
        homeFeedTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            homeFeedTable.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            homeFeedTable.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            homeFeedTable.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            homeFeedTable.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

     func setupTableView() {
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        heroView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 360
        )

        heroView.onViewDetailsTapped = { [weak self] in
            self?.openDetails(for: self?.viewModel.heroContent)
        }

        homeFeedTable.tableHeaderView = heroView
    }

     func configureNavigationBar() {
        navigationItem.title = "OTT Platform"

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
//MARK: Bind data here
     func bindViewModel() {
        viewModel.onContentUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let hero = self?.viewModel.heroContent else {
                    return
                }
                self?.heroView.titleLbl.text = hero.title
                self?.heroView.descriptionLbl.text = hero.description
//                if let imgData = try? Data(contentsOf: hero.thumbnailURL){
//                    self?.heroView.heroImgView.image = UIImage(data: imgData)
//                }
                URLSession.shared.dataTask(with: hero.thumbnailURL) { data, _, _ in
                    guard let data = data,
                          let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        self?.heroView.heroImgView.image = image
                    }
                }.resume()
                self?.homeFeedTable.reloadData()
            }
            self?.loadingIndicator.stopAnimating()
        }
    }

     func openDetails(for content: Content?) {
//         guard let content = content else { return }
//
//         let player = AVPlayer(url: content.videoURL)
//         player.isMuted = false
//         let playerVC = CustomVideoPlayerViewController()
//         playerVC.player = player
//         playerVC.modalPresentationStyle = .fullScreen
//         present(playerVC, animated: true) {
//             player.play()
//         }

        guard let content else { return }
        let detailVC = ContentDetailViewController(content: content)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}





extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentRailTableViewCell", for: indexPath) as! ContentRailTableViewCell
        let contents = indexPath.section == 0 ? viewModel.trendingContent : viewModel.recommendedContent

        cell.contents = contents
        cell.onContentSelected = { [weak self] content in
            self?.openDetails(for: content)
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .systemFont(
            ofSize: 18,
            weight: .semibold
        )
        header.contentView.backgroundColor = .black
    }
    
}
