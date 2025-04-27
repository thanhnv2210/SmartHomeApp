//
//  ContentView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State private var devices: [Device] = [] // Store the list of devices
    @State private var selectedDevice: Device? // Store the selected device
    
    var body: some View {
        NavigationView {
            List(devices) { device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    HStack {
                        Text(device.name)
                        Spacer()
                        Text(device.status)
                            .foregroundColor(device.status == "ON" ? .green : .red) // Color based on status
                    }
                }
            }
            .navigationTitle("Smart Home Devices")
            .onAppear {
                loadDeviceData() // Load device data when the view appears
            }
        }
    }
    
    private func loadDeviceData() {
        let ref = Database.database().reference().child("devices")
        ref.observeSingleEvent(of: .value) { snapshot in
            if let devicesDict = snapshot.value as? [String: Any] {
                var fetchedDevices: [Device] = []
                let group = DispatchGroup() // Use DispatchGroup to wait for history fetching
                
                for (key, value) in devicesDict {
                    if let deviceData = value as? [String: Any],
                       let name = deviceData["name"] as? String,
                       let status = deviceData["status"] as? String,
                       let lastWatered = deviceData["last_watered"] as? String,
                       let scheduleData = deviceData["schedule"] as? [String: Any],
                       let morning = scheduleData["morning"] as? String,
                       let evening = scheduleData["evening"] as? String,
                       let durationMinutes = scheduleData["duration_minutes"] as? Int {
                        
                        let schedule = Device.Schedule(morning: morning, evening: evening, durationMinutes: durationMinutes)

                        // Start fetching history in parallel
                        group.enter() // Enter the group
                        fetchHistory(for: key) { history in
                            let device = Device(name: name, status: status, lastWatered: lastWatered, schedule: schedule, history: history)
                            fetchedDevices.append(device) // Append to the fetched devices
                            group.leave() // Leave the group
                        }
                    }
                }
                
                // Notify when all history fetching is done
                group.notify(queue: .main) {
                    devices = fetchedDevices // Update UI with fetched devices
                }
            }
        }
    }
    
    private func fetchHistory(for deviceId: String, completion: @escaping ([String: Device.HistoryEntry]) -> Void) {
        let ref = Database.database().reference().child("logHistory").child(deviceId)
        ref.observeSingleEvent(of: .value) { snapshot in
            var history: [String: Device.HistoryEntry] = [:]
            if let historyDict = snapshot.value as? [String: Any] {
                for (date, entry) in historyDict {
                    if let entryData = entry as? [String: Any],
                       let action = entryData["action"] as? String,
                       let durationSeconds = entryData["duration_seconds"] as? Int,
                       let status = entryData["status"] as? String {
                        let historyEntry = Device.HistoryEntry(action: action, durationSeconds: durationSeconds, status: status)
                        history[date] = historyEntry // Store in history dictionary
                    }
                }
            }
            completion(history) // Return the history data
        }
    }
}

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
                    }
                }
            }
        }
        .navigationTitle(device.name)
    }
}
