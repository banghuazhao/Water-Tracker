//
//  CoreDataManager.swift
//  BMI Diary
//
//  Created by Banghua Zhao on 7/4/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import CoreData
import SwiftDate

struct CoreDataManager {
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()

    func fetchLocalWaterRecords() -> [WaterRecord] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<WaterRecord>(entityName: "WaterRecord")
        do {
            let userWeights = try context.fetch(fetchRequest)
            return userWeights
        } catch let fetchErr {
            print("Failed to fetch User WaterRecord:", fetchErr)
            return []
        }
    }

    func findTodayWaterRecord() -> WaterRecord? {
        let waterRecords = CoreDataManager.shared.fetchLocalWaterRecords()
        let todayWaterRecord = waterRecords.last { (waterRecord) -> Bool in
            guard let date = waterRecord.date else { return false }
            return date.isToday
        }
        return todayWaterRecord
    }

    func createTodayWaterRecord() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let waterRecord = NSEntityDescription.insertNewObject(forEntityName: "WaterRecord", into: context) as! WaterRecord

        waterRecord.setValue(Date(), forKey: "date")
        waterRecord.setValue(false, forKey: "glass0")
        waterRecord.setValue(false, forKey: "glass1")
        waterRecord.setValue(false, forKey: "glass2")
        waterRecord.setValue(false, forKey: "glass3")
        waterRecord.setValue(false, forKey: "glass4")
        waterRecord.setValue(false, forKey: "glass5")
        waterRecord.setValue(false, forKey: "glass6")
        waterRecord.setValue(false, forKey: "glass7")

        // perform the save
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save user WaterRecord:", saveErr)
        }
    }

    func refreshTodayWaterRecord() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let waterRecords = CoreDataManager.shared.fetchLocalWaterRecords()
        let todayWaterRecord = waterRecords.last { (waterRecord) -> Bool in
            guard let date = waterRecord.date else { return false }
            return date.isToday
        }
        todayWaterRecord?.glass0 = false
        todayWaterRecord?.glass1 = false
        todayWaterRecord?.glass2 = false
        todayWaterRecord?.glass3 = false
        todayWaterRecord?.glass4 = false
        todayWaterRecord?.glass5 = false
        todayWaterRecord?.glass6 = false
        todayWaterRecord?.glass7 = false
        // perform the save
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save user WaterRecord:", saveErr)
        }
    }

    func getGlassses(waterRecord: WaterRecord) -> Int {
        var glasses = 0
        if waterRecord.glass0 { glasses += 1 }
        if waterRecord.glass1 { glasses += 1 }
        if waterRecord.glass2 { glasses += 1 }
        if waterRecord.glass3 { glasses += 1 }
        if waterRecord.glass4 { glasses += 1 }
        if waterRecord.glass5 { glasses += 1 }
        if waterRecord.glass6 { glasses += 1 }
        if waterRecord.glass7 { glasses += 1 }
        return glasses
    }
}
