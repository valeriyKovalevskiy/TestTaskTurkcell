//
//  Query.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation
import CoreData

//swiftlint:disable force_try
final class Query <T: NSManagedObject> {
    
    class func fetchRequest(
        filteredBy filter: NSPredicate? = nil,
        orderedBy order: [NSSortDescriptor]? = nil,
        limit: Int = 0
    ) -> NSFetchRequest<NSFetchRequestResult> {
        let entityName = T.entityName()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = filter
        request.sortDescriptors = order
        request.fetchLimit = limit
        
        return request
    }

    class func any(
        filteredBy filter: NSPredicate? = nil,
        orderedBy order: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext
    ) -> T? {
        return all(filteredBy: filter, orderedBy: order, limit: 1, inContext: context).first
    }
    
    class func only(in context: NSManagedObjectContext) throws -> T? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName())
        
        do {
            let models = try context.fetch(request)
            if models.count == 0 {
                return nil
            }
            return models.first as? T
        } catch let error {
            throw error
        }
    }
    
    class func all(
        filteredBy filter: NSPredicate? = nil,
        orderedBy order: [NSSortDescriptor]? = nil,
        limit: Int = 0,
        inContext context: NSManagedObjectContext
    ) -> [T] {
        let request = fetchRequest(filteredBy: filter, orderedBy: order, limit: limit)
        return try! context.fetch(request) as! [T]
    }
    
    class func all(request: NSFetchRequest<NSFetchRequestResult>, in context: NSManagedObjectContext) -> [T]? {
        assert(request.entityName == T.entityName())
        return try? context.fetch(request) as? [T]
     }
    
    class func count(filteredBy filter: NSPredicate? = nil, in context: NSManagedObjectContext) -> Int? {
        let request = fetchRequest(filteredBy: filter)
        return try? context.count(for: request)
    }
    
    class func delete(filteredBy filter: NSPredicate? = nil, in context: NSManagedObjectContext) {
        let request = fetchRequest(filteredBy: filter)
        request.includesPropertyValues = false
        
        if let objects = all(request: request, in: context) {
            for object in objects {
                context.delete(object)
            }
        }
    }
    
    class func model(_ identifier: String, context: NSManagedObjectContext) -> T? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName())
        request.entity = NSEntityDescription.entity(forEntityName: T.entityName(), in: context)
        request.predicate = NSPredicate(format: "modelId = %@", identifier)
        
        do {
            let models = try context.fetch(request)
            assert(models.count <= 1, "Duplicated objects")
            return models.first as? T
        } catch {
            return nil
        }
    }
    
}

extension NSManagedObject {

    public class func entityName() -> String {
        return NSStringFromClass(self)
    }
}
//swiftlint:enable force_try
