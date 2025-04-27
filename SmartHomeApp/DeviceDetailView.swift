//
//  DeviceDetailView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct DeviceDetailView: View {
    @State var device: Device // Use @State to modify the device in this view
    @State private var isEditing: Bool = false
    @State private var updateMessage: String = ""

    var body: some View {
        Form {
            Section(header: Text("Device Info")) {
                HStack {
                    if isEditing {
                        TextField("Device Name", text: Binding(
                            get: { device.name },
                            set: { device.name = $0 } // Update name inline
                        ))
                        
                        Button(action: {
                            updateDeviceNameInFirebase()
                        }) {
                            Text("Update")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text(device.name)
                        Button(action: {
                            isEditing.toggle() // Toggle edit mode
                            updateMessage = "" // Clear any previous success message
                        }) {
                            Image(systemName: "pencil") // Edit icon
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                HStack {
                    Text("Current Status: \(device.status)")
                    Spacer() // This pushes the button to the right
                    Button(action: {
                        toggleDeviceStatus() // Toggle status when button is pressed
                    }) {
                        Text(device.status == "ON" ? "Turn OFF" : "Turn ON")
                            .foregroundColor(device.status == "ON" ? .red : .green)
                            .padding(8)
                            .background(Color.gray.opacity(0.2)) // Optional: add background
                            .cornerRadius(5) // Optional: round corners
                    }
                }
            }

            // Display update message
            if !updateMessage.isEmpty {
                Text(updateMessage)
                    .foregroundColor(.green)
                    .padding()
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
        // Update Firebase with the new status
        updateDeviceStatusInFirebase()
    }

    private func updateDeviceNameInFirebase() {
        let deviceService = DeviceService()
        deviceService.updateDeviceName(device.id, name: device.name) { success in
            if success {
                updateMessage = "Device name updated successfully!" // Set success message
                isEditing = false // Exit edit mode after successful update
            } else {
                updateMessage = "Failed to update device name." // Error message
            }
        }
    }

    private func updateDeviceStatusInFirebase() {
        let deviceService = DeviceService()
        deviceService.updateDeviceStatus(device.id, status: device.status) // Update status in Firebase
    }
}
