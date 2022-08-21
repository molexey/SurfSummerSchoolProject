//
//  SearchViewController.swift
//  SurfEducationProject
//
//  Created by molexey on 17.08.2022.
//

import UIKit

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horisontalInset: CGFloat = 16
        static let spaceBetweenElements: CGFloat = 7
        static let spaceBetweenRows: CGFloat = 8
    }
    
    // MARK: - Private properties
    
    private let model = SearchModel()
    
    // MARK: - Views
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSearchBar()
        configureNavigationBar()
        configureModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
}

// MARK: - UICollection

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainItemCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? MainItemCollectionViewCell {
            let item = model.items[indexPath.row]
            cell.title = item.title
            cell.isFavorite = item.isFavorite
            cell.imageUrlInString = item.imageUrlInString
            cell.didFavoritesTapped = { [weak self] in
                self?.model.items[indexPath.row].isFavorite.toggle()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - Constants.horisontalInset * 2 - Constants.spaceBetweenElements) / 2
        return CGSize(width: itemWidth, height: 1.46 * itemWidth)
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

// MARK: - Private Methods

private extension SearchViewController {
    
    func configureAppearance() {
        collectionView.register(UINib(nibName: "\(MainItemCollectionViewCell.self)", bundle: .main),
                                forCellWithReuseIdentifier: "\(MainItemCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "back-arrow"),
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func configureSearchBar() {
        
        let customFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 44)
        let searchBarContainer = UIView(frame: customFrame)
        let searchBar = UISearchBar(frame: customFrame)
        searchBarContainer.addSubview(searchBar)
        navigationItem.titleView = searchBarContainer
        
        let barFrame = searchBar.frame
        searchBar.frame = CGRect(x: 0, y: 0, width: barFrame.width, height: 44)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = UIColor(displayP3Red: 0xF5 / 255, green: 0xF5 / 255, blue: 0xF5 / 255, alpha: 1)
        searchBar.textField?.placeholder = "Поиск"
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 6, vertical: 0)
        
        searchBar.setImage(UIImage(named: "searchBarButton"), for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        searchBar.setImage(UIImage(named: "searchBarClear"), for: .clear, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -6, vertical: 0), for: .clear)
    }
    
    func configureModel() {
        model.didItemsUpdated = { [weak self] in
            DispatchQueue.main.async() {
                self?.collectionView.reloadData()
            }
        }
    }
    
}

// MARK: Extension for UISearchBar delegate

extension SearchViewController: UISearchBarDelegate {
        
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.search(input: searchText)
        if searchBar.text == "" {
            //                    isSearching = false
            self.collectionView.reloadData()
        } else {
            self.collectionView.reloadData()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    public func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
    
}

