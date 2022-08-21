//
//  FavoriteModel.swift
//  SurfEducationProject
//
//  Created by molexey on 20.08.2022.
//

import Foundation
import UIKit

final class FavoriteModel {

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
    
    let favoriteService = FavoriteService()


    // MARK: - Methods
    
    func loadPosts() {
        items = MainModel.shared.items.filter { $0.isFavorite }
    }
    
    func favoriteToggle(item: DetailItemModel) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func updateFavorites() {
        let filteredItems = items.filter { $0.isFavorite }
        favoriteService.storage.saveItems(itemArray: filteredItems.map { $0.id })
    }

}
