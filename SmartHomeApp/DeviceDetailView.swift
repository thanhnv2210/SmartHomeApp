//
//  DeviceDetailView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct DeviceDetailView: View {
    @State var device: Device // Use @State to modify the device in this view

    var body: some View {
        Form {
            Section(header: Text("Device Info")) {
                TextField("Device Name", text: Binding(
                    get: { device.name },
                    set: { device.name = $0 } // Update name inline
                ))

                Text("Current Status: \(device.status)")
                Button(action: {
                    toggleDeviceStatus() // Toggle status when button is pressed
                }) {
                    Text(device.status == "ON" ? "Turn OFF" : "Turn ON")
                        .foregroundColor(device.status == "ON" ? .red : .green)
                }
            }

            Section(header: Text("Last Watered")) {
                Text(device.lastWatered)
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

    private func toggleDeviceStatus() {
        device.toggleStatus()
        // Here, you would also want to update Firebase with the new status
        updateDeviceStatusInFirebase()
    }

    private func updateDeviceStatusInFirebase() {
        let deviceService = DeviceService()
        print(device)
        deviceService.updateDeviceStatus(device.id, status: device.status) // Pass appropriate parameters to update status in the back-end
    }
}
