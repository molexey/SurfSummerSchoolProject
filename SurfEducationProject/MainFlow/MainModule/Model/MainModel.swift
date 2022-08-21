//
//  MainModel.swift
//  SurfEducationProject
//
//  Created by Владислав Климов on 04.08.2022.
//

import Foundation
import UIKit

final class MainModel {
    
    static let shared = MainModel()
    
    private init() {}

    // MARK: - Events

    var didItemsUpdated: (() -> Void)?

    // MARK: - Properties

    let pictureService = PicturesService()
    var items: [DetailItemModel] = [] {
        didSet {
            didItemsUpdated?()
            updateFavorites()
        }
    }
    
    private let favoriteService = FavoriteService()

    // MARK: - Methods

    func loadPosts() {
        pictureService.loadPictures { [weak self] result in
            switch result {
            case .success(let pictures):
                self?.items = pictures.map { pictureModel in
                    DetailItemModel(
                        id: pictureModel.id,
                        imageUrlInString: pictureModel.photoUrl,
                        title: pictureModel.title,
                        isFavorite: { (self?.favoriteService.isFavorite(id: pictureModel.id))!}(),
                        content: pictureModel.content,
                        dateCreation: pictureModel.date
                    )
                }
            case .failure(let error):
                // TODO: - Implement error state there
                break
            }
        }
    }
    
    func updateFavorites() {
        let favorites = items.filter { $0.isFavorite }
        favoriteService.storage.saveItems(itemArray: favorites.map { $0.id })
    }

}
