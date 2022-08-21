//
//  FavoriteViewController.swift
//  SurfEducationProject
//
//  Created by Malygin Georgii on 03.08.2022.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    // MARK: - Constants

    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let spaceBetweenElements: CGFloat = 7
        static let spaceBetweenRows: CGFloat = 27
    }
    
    // MARK: - Private properties
    
    private let model: FavoriteModel = .init()
    
    // MARK: - Views

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifeсyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureNavigationBar()
        configureModel()
        model.loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        model.loadPosts()
    }
    
    // MARK: - Actions
    
    @objc private func searchButtonTapped() {
        print("searchButtonTapped")
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
}

// MARK: - Private Methods

private extension FavoriteViewController {

    func configureAppearance() {
        collectionView.register(UINib(nibName: "\(FavoriteItemCollectionViewCell.self)", bundle: .main),
                                forCellWithReuseIdentifier: "\(FavoriteItemCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }

    func configureNavigationBar() {
        navigationItem.title = "Избранное"
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func configureModel() {
        model.didItemsUpdated = { [weak self] in
                self?.collectionView.reloadData()
        }
    }

}

// MARK: - UICollection

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FavoriteItemCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? FavoriteItemCollectionViewCell {
            let item = model.items[indexPath.row]
            cell.title = item.title
            cell.content = item.content
            cell.date = item.dateCreation
            cell.isFavorite = item.isFavorite
            cell.imageUrlInString = item.imageUrlInString
            cell.didFavoriteTapped = { [weak self] in
                guard let self = self else { return }
                self.showRemoveAlert(item: self.model.items[indexPath.row])
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.layer.bounds.width - Constants.horizontalInset * 2)
        let itemHeight = itemWidth * 1.16
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenRows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenElements
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.model = model.items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

private extension FavoriteViewController {
    
    func showRemoveAlert(item: DetailItemModel) {
        let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите удалить из избранного?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Да, точно", style: .default, handler: { (action) in
            
            // TODO: - Add action
            self.model.favoriteToggle(item: item)
            
        }))
        
        alert.preferredAction = alert.actions[1]
        present(alert, animated: true, completion: nil)
    }

}

