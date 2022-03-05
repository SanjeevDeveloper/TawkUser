//
//  CoreDataStorage.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation
import CoreData
import UIKit

final class CoreDataStorage
{
    private init(){}
    static let shared = CoreDataStorage()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]?
    {
        do {
            guard let result = try CoreDataStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {return nil
            }
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }

    func printDocumentDirectoryPath() {
       debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}
