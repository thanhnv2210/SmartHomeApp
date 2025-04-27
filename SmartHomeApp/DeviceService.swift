//
//  DeviceService.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import FirebaseDatabase

// Class to handle Firebase operations for devices
class DeviceService {
    private let ref = Database.database().reference().child("devices")

    // Load devices from Firebase
    func loadDevices(completion: @escaping ([Device]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            var fetchedDevices: [Device] = []
            let group = DispatchGroup() // Use DispatchGroup to wait for history fetching

            if let devicesDict = snapshot.value as? [String: Any] {
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
                        
                        let device = Device(
                            deviceId: key, // Use the Firebase key as the deviceId
                            name: name,
                            status: status,
                            lastWatered: lastWatered,
                            schedule: schedule
                        )
                        
                        // Optionally, fetch history for this device
                        group.enter()
                        self.fetchHistory(for: key) { history in
                            var deviceWithHistory = device
                            deviceWithHistory.history = history
                            fetchedDevices.append(deviceWithHistory)
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    completion(fetchedDevices) // Return all fetched devices
                }
            } else {
                completion([]) // Return an empty array if fetch fails
            }
        }
    }
    
    // Fetch history for a specific device
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
                        history[date] = historyEntry // Store history
                    }
                }
            }
            completion(history) // Return fetched history
        }
    }

    // Method to update device status in Firebase
    func updateDeviceStatus(_ deviceId: String, status: String) {
        ref.child(deviceId).child("status").setValue(status) { error, _ in
            if let error = error {
                print("Error updating device status: \(error.localizedDescription)")
            } else {
                print("Device status updated successfully to \(status) for device ID: \(deviceId).")
            }
        }
    }

    // Method to update device name in Firebase with a completion handler
    func updateDeviceName(_ deviceId: String, name: String, completion: @escaping (Bool) -> Void) {
        ref.child(deviceId).child("name").setValue(name) { error, _ in
            if let error = error {
                print("Error updating device name: \(error.localizedDescription)")
                completion(false) // Indicate failure
            } else {
                print("Device name updated successfully to \(name) for device ID: \(deviceId).")
                completion(true) // Indicate success
            }
        }
    }
}
