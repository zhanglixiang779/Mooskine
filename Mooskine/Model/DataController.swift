//
//  DataController.swift
//  Mooskine
//
//  Created by Lixiang Zhang on 2/12/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error?.localizedDescription ?? "")
            }
            
            self.autoSaveViewContext()
            completion?()
        }
    }
}

extension DataController {
    private func autoSaveViewContext(interval: TimeInterval = 30) {
        print("auto saving")
        guard interval > 0 else {
            print("cannot set negative interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}


