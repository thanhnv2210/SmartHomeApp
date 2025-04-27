//
//  DeviceDetailView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct DeviceDetailView: View {
    let device: Device

    var body: some View {
        Form {
            Section(header: Text("Status")) {
                Text("Current Status: \(device.status)")
                Text("Last Watered: \(device.lastWatered)")
            }
            
            Section(header: Text("Schedule")) {
                Text("Morning: \(device.schedule.morning)")
                Text("Evening: \(device.schedule.evening)")
                Text("Duration: \(device.schedule.durationMinutes) minutes")
            }
            
            Section(header: Text("History")) {
                ForEach(device.history.keys.sorted(), id: \.self) { key in
                    if let entry = device.history[key] {
                        VStack(alignment: .leading) {
                            Text("Date: \(key)")
                            Text("Action: \(entry.action)")
                            Text("Duration: \(entry.durationSeconds) seconds")
                            Text("Status: \(entry.status)")
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
