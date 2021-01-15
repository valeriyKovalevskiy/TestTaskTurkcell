//
//  CoreDataStack.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    var storeURL: URL! {
        return applicationDocumentsDirectory.appendingPathComponent("\(Constants.Storage.ModelName).sqlite")
    }
    
    fileprivate(set) lazy var managedObjectContext: NSManagedObjectContext = { [unowned self] in
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSRollbackMergePolicy
        return context
    }()
    
    var asynchManagedObjectContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSRollbackMergePolicy
        return context
    }
    
    // MARK: - Model
    fileprivate(set) lazy var managedObjectModel: NSManagedObjectModel = { [unowned self] in
        let url = Bundle.main.url(forResource: Constants.Storage.ModelName, withExtension: "momd")
        assert(url != nil, "Can't find model with url (\(Constants.Storage.ModelName))")
        
        let model = NSManagedObjectModel(contentsOf: url!)!
        return model
    }()
    
    // MARK: - Coordinator
    fileprivate(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { [unowned self] in
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        self.loadPersistentStore(coordinator)
        return coordinator
        }()
    
    fileprivate var applicationDocumentsDirectory: URL! {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    fileprivate let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
    
    // MARK: Private funcs
    fileprivate func loadPersistentStore(_ coordinator: NSPersistentStoreCoordinator) {
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: self.storeURL,
                options: options
            )
            print("Persistant store loaded")
        } catch let error {
            assertionFailure("Failed to add persistent store with error = \(error)\n aborting...")
        }
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            //TODO: Handle error properly
            print(error)
        }
    }
    
    func removeAllData() {
        let store = persistentStoreCoordinator.persistentStores.first
        do {
            try persistentStoreCoordinator.remove(store!)
            try FileManager.default.removeItem(at: self.storeURL)
        } catch {
            print("Failed to remove persistent store \(error)")
        }
        loadPersistentStore(persistentStoreCoordinator)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSRollbackMergePolicy
        managedObjectContext = context
    }
}
