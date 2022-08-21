//
//  SearchModel.swift
//  SurfEducationProject
//
//  Created by molexey on 19.08.2022.
//

import Foundation

class SearchModel {
    
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
    
    // TODO: - Fix update favorite status
    
    // MARK: - Methods
    
    func search(input: String) {
        items = []
        
        items = MainModel.shared.items.filter({ item in
            item.title.lowercased().contains(input.lowercased())
        })
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
