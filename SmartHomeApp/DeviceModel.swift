//
//  Device.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation

// Device struct representing device data
struct Device: Identifiable {
    var id: String { name }
    let name: String
    var status: String
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
}
