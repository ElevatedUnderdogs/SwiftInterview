//
//  NSPersistentContainer.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import CoreData

// modular
public extension NSPersistentContainer {
    
    static var new: NSPersistentContainer {
        let container = NSPersistentContainer(name: "akin")
        container.loadPersistentStores { (storeDescription, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return container
    }
    
    func save() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error {
            print("An error occured when attempting to save the context \(error.localizedDescription)")
        }
    }
}
