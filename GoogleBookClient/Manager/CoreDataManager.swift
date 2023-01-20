//
//  CoreDataManager.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 20/1/23.
//

import CoreData
// MARK: - CoreDataManager
    
class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//let context = appDelegate.persistentContainer.viewContext
//
//
//    lazy var persistentContainer: NSPersistentContainer = {
//
////        let bundle = Bundle.module
////        guard let modelURL = bundle.url(forResource: "SweetHomeMap_1_2", withExtension: ".momd"), let model = NSManagedObjectModel(contentsOf: modelURL) else { return (NSPersistentContainer())
////        }
////          let container = NSPersistentCloudKitContainer(name: "SweetHomeMap_1_2", managedObjectModel: model)
//
//        let container = NSPersistentContainer(name: "Model")
//
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
//
//    func entityForName(entityName: String) -> NSEntityDescription {
//        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
//    }
//
//    // MARK: - Core Data Saving support
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}






//
//// MARK: - Core Data stack
//
//lazy var persistentContainer: NSPersistentContainer = {
//
//    let container = NSPersistentContainer(name: "MoneySafe")
//    
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//        if let error = error as NSError? {
//            fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//    })
//    
//    return container
//}()
