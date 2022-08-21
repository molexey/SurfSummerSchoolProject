//
//  FavoriteService.swift
//  SurfEducationProject
//
//  Created by molexey on 20.08.2022.
//

import Foundation

final class FavoriteService {
    
    // MARK: - Public properties
    
    var storage = FavoriteStorage.shared
    
    // MARK: - Public methods
    
    func isFavorite(id: String) -> Bool {
        
        return self.storage.loadItems().contains(id)
    }
    
}
