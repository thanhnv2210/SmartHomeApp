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

    func loadDevices(completion: @escaping ([Device]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            var fetchedDevices: [Device] = []
            let group = DispatchGroup()

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

                        group.enter()
                        self.fetchHistory(for: key) { history in
                            let device = Device(name: name, status: status, lastWatered: lastWatered, schedule: schedule, history: history)
                            fetchedDevices.append(device)
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    completion(fetchedDevices)
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
                        history[date] = historyEntry
                    }
                }
            }
            completion(history)
        }
    }
}
