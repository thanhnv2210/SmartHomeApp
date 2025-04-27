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
    var schedule: Schedule
    var history: [String: HistoryEntry] = [:]

    struct Schedule {
        var morning: String
        var evening: String
        var durationMinutes: Int
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
