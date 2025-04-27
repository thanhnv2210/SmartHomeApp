//
//  Device.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation

// Device struct representing device data
struct Device: Identifiable {
    var id: String { deviceId } // deviceId will be used for mapping
    let deviceId: String // Unique identifier for the device
    var name: String // Change this to var to allow modification
    var status: String // "ON" or "OFF"
    var lastWatered: String
    var schedules: [Schedule] // Change to an array to hold multiple schedules
    var history: [String: HistoryEntry] = [:]
    
    struct Schedule: Identifiable {
        var id: String { name } // Assuming name is unique for the schedule
        var name: String
        var selectedDays: [String] // Store selected days of the week (e.g., ["SUN", "MON"])
        var startTime: Date // Store the start time as a Date
        var durationMinutes: Int // Store the duration in minutes
        
        init(name: String, selectedDays: [String] = [], startTime: Date = Date(), durationMinutes: Int = 0) {
            self.name = name
            self.selectedDays = selectedDays
            self.startTime = startTime
            self.durationMinutes = durationMinutes
        }
    }

    struct HistoryEntry {
        var action: String
        var durationSeconds: Int
        var status: String
    }
    
    mutating func toggleStatus() {
        status = (status == "ON") ? "OFF" : "ON"
    }
}
