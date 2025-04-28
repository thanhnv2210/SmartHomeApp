//
//  FirebaseManager.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager() // Singleton instance
    private let ref: DatabaseReference

    init() {
        self.ref = Database.database().reference()
    }

    // Read device info
    func readDeviceInfo(deviceId: String, completion: @escaping ([String: Any]?) -> Void) {
        ref.child("devices").child(deviceId).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                completion(dict)
            } else {
                completion(nil)
            }
        }
    }

    // Update device status
    func updateDeviceStatus(deviceId: String, status: String, completion: @escaping (Error?) -> Void) {
        ref.child("devices").child(deviceId).child("status").setValue(status) { error, _ in
            completion(error)
        }
    }

    // Update last watered time
    func updateLastWatered(deviceId: String, dateTime: String, completion: @escaping (Error?) -> Void) {
        ref.child("devices").child(deviceId).child("last_watered").setValue(dateTime) { error, _ in
            completion(error)
        }
    }

    // Example method to log history
    func logHistory(deviceId: String, action: String, duration: Int, status: String, completion: @escaping (Error?) -> Void) {
        let historyNode = [DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short): [
            "action": action,
            "duration_seconds": duration,
            "status": status
        ]] as [String: Any]
        
        ref.child("devices").child(deviceId).child("history").updateChildValues(historyNode) { error, _ in
            completion(error)
        }
    }
    
    func loadUserProfile(userId: String, completion: @escaping (UserProfile?) -> Void) {
        ref.child("account").child(userId).observeSingleEvent(of: .value) { snapshot  in
            guard let profileData = snapshot.value as? [String: Any],
                  let accountName = profileData["accountName"] as? String,
                  let name = profileData["name"] as? String,
                  let id = snapshot.key as? String,
                  let createDateString = profileData["create_datetime"] as? String,
                  let status = profileData["status"] as? String,
                  let activeDevices = profileData["active_devices"] as? Int,
                  let maxDevices = profileData["max_devices"] as? Int,
                  let packageType = profileData["package_type"] as? String,
                  let createDate = ISO8601DateFormatter().date(from: createDateString) else {
                print("⚠️ Failed to parse user profile for userId: \(userId)")
                print(snapshot.value as Any)
                completion(nil) // Return nil if parsing fails
                return
            }
            
            let userProfile = UserProfile(
                id: id, 
                accountName: accountName,
                name: name,
                createDate: createDate,
                status: status,
                activeDevices: activeDevices,
                maxDevices: maxDevices,
                packageType: packageType,
            )
            completion(userProfile) // Return the parsed user profile
        }
    }
    
    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Bool) -> Void) {
        let profileData: [String: Any] = [
            "accountName": userProfile.accountName,
            "name": userProfile.name,
            "create_datetime": ISO8601DateFormatter().string(from: userProfile.createDate),
            "status": userProfile.status,
            "active_devices": userProfile.activeDevices,
            "max_devices": userProfile.maxDevices,
            "package_type": userProfile.packageType
        ]
        
        ref.child("account").child(String(userProfile.id)).setValue(profileData) { error, _ in
            if let error = error {
                print("Error saving user profile: \(error.localizedDescription)")
                completion(false) // Indicate failure
            } else {
                print("User profile saved successfully for user ID: \(userProfile.id)")
                completion(true) // Indicate success
            }
        }
    }
    
    func loadDevices(userId: String, completion: @escaping ([Device]) -> Void) {
        ref.child("devices").child(userId).observeSingleEvent(of: .value) { snapshot in
            var fetchedDevices: [Device] = []
            let group = DispatchGroup() // Use DispatchGroup to wait for history fetching

            if let devicesDict = snapshot.value as? [String: Any] {
                for (key, value) in devicesDict {
                    if let deviceData = value as? [String: Any],
                       let name = deviceData["name"] as? String,
                       let status = deviceData["status"] as? String,
                       let lastWatered = deviceData["last_watered"] as? String {

                        // Create the Device object with the fetched data
                        let device = Device(
                            deviceId: key,
                            name: name,
                            status: status,
                            lastWatered: lastWatered,
                        )
                        fetchedDevices.append(device)
                    }
                }
                completion(fetchedDevices)
            } else {
                completion([]) // Return an empty array if fetch fails
            }
        }
    }
    
    // Method to update device name in Firebase with a completion handler
    func updateDeviceName(_ accountId: String,_ deviceId: String, name: String, completion: @escaping (Bool) -> Void) {
        ref.child("devices").child(accountId).child(deviceId).child("name").setValue(name) { error, _ in
            if let error = error {
                print("Error updating device name: \(error.localizedDescription)")
                completion(false) // Indicate failure
            } else {
                print("Device name updated successfully to \(name) for device ID: \(deviceId).")
                completion(true) // Indicate success
            }
        }
    }

    // Method to update device status in Firebase
    func updateDeviceStatus(_ accountId: String,_ deviceId: String, status: String) {
        ref.child("devices").child(accountId).child(deviceId).child("status").setValue(status) { error, _ in
            if let error = error {
                print("Error updating device status: \(error.localizedDescription)")
            } else {
                print("Device status updated successfully to \(status) for device ID: \(deviceId).")
            }
        }
    }
    
    // Fetch history for a specific device
    public func fetchHistory(for deviceId: String, completion: @escaping ([String: Device.HistoryEntry]) -> Void) {
        ref.child("logHistory").child(deviceId).observeSingleEvent(of: .value) { snapshot in
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
}
