//
//  FavoriteSrorage.swift
//  SurfEducationProject
//
//  Created by molexey on 21.08.2022.
//

import Foundation

struct FavoriteStorage {
    
    static let shared = FavoriteStorage()
    
    private init() {}
    
    // MARK: - Private properties
    
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("FavoriteItems.plist")
    
    func saveItems(itemArray: [String]) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    // MARK: - Public methods
    
    func loadItems() -> ([String]) {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            let itemArray: [String]
            do {
                itemArray = try decoder.decode([String].self, from: data)
                return itemArray
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
        return []
    }
    
    func removeDataFile() {
        do {
            guard let dataFilePath = dataFilePath else { return }
            try FileManager.default.removeItem(at: dataFilePath)
        } catch let error as NSError {
            print("An error took place: \(error)")
            
            //        do {
            //             let fileManager = FileManager.default
            //
            //            if fileManager.fileExists(atPath: filePath) {
            //                try fileManager.removeItem(atPath: filePath)
            //            } else {
            //                print("File does not exist")
            //            }
            //
            //        }
            //        catch let error as NSError {
            //            print("An error took place: \(error)")
        }

    }
    
}
