//
//  DataBasePersistenceManager.swift
//  Netflix
//
//  Created by KH on 28/02/2023.
//

import UIKit
import CoreData


final class DataBasePersistenceManager {
   
    static let shared = DataBasePersistenceManager()
    
    private init() {}
    
    public func downloadTitleWith(model: Title, complition: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.vote_count = Int64(model.vote_count)
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            complition(.success(()))
        } catch let error {
            complition(.failure(error))
        }
        
    }
    
    // MARK: - Fetching Data from Database
    public func fetchDataFromDB(complition: (Result<[TitleItem], Error>) -> ()) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            complition(.success(titles))
        } catch let error {
            complition(.failure(error))
        }
    }
    
    // MARK: - Delete
    public func delete(item titleItem: TitleItem, complition: (Result<String, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(titleItem)
        
        do {
            try context.save()
            complition(.success("Delete Item"))
        } catch let error {
            complition(.failure(error))
        }
    }
}
