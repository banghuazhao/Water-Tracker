//
//  ReminderTimeStore.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/1/31.
//

import Foundation

class ReminderTimeStore {
    static let coreDataContext = CoreDataManager.shared.persistentContainer.viewContext

    static let shared = ReminderTimeStore()

    private var items: [ReminderTime] = [] {
        didSet {
            saveCoreData()
        }
    }

    private init() {}

    func add(item: ReminderTime) {
        let index = items.insertionIndexOf(item) { $0.time!.timeOfHourAndMinutes < $1.time!.timeOfHourAndMinutes }
        items.insert(item, at: index)
    }

    func remove(item: ReminderTime) {
        guard let index = items.firstIndex(of: item) else { return }
        remove(at: index)
    }

    func remove(at index: Int) {
        guard items.count > index else { return }
        let item = items[index]
        ReminderTimeStore.coreDataContext.delete(item)
        items.remove(at: index)
    }

    func edit(original: ReminderTime, new: ReminderTime) {
        guard let index = items.firstIndex(of: original) else { return }
        items[index] = new
        items.sort { (reminderTime1, reminderTime2) -> Bool in
            reminderTime1.time!.timeOfHourAndMinutes < reminderTime2.time!.timeOfHourAndMinutes
        }
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> ReminderTime {
        return items[index]
    }

    func index(for event: ReminderTime) -> Int? {
        return items.firstIndex(of: event)
    }

    func hasTime(for time: Date) -> Bool {
        return items.contains { (reminderTime) -> Bool in
            reminderTime.time!.timeOfHourAndMinutes == time.timeOfHourAndMinutes
        }
    }

    func fetchAllFromLocal() {
        var reminderTimes = CoreDataManager.shared.fetchLocalReminderTimes()
        if reminderTimes.count > 1 {
            reminderTimes.sort { (reminderTime1, reminderTime2) -> Bool in
                reminderTime1.time!.timeOfHourAndMinutes < reminderTime2.time!.timeOfHourAndMinutes
            }
        }
        items = reminderTimes
    }

    func saveCoreData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save Event:", saveErr)
        }
    }
}
