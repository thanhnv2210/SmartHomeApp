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
//            print(snapshot.key ?? "No key available")
            print(snapshot)
            guard let profileData = snapshot.value as? [String: Any],
                  let accountName = profileData["accountName"] as? String,
                  let name = profileData["name"] as? String,
                  let id = profileData["id"] as? Int,
                  let createDateString = profileData["create_datetime"] as? String,
                  let status = profileData["status"] as? String,
                  let activeDevices = profileData["active_devices"] as? Int,
                  let maxDevices = profileData["max_devices"] as? Int,
                  let packageType = profileData["package_type"] as? String,
                  let createDate = ISO8601DateFormatter().date(from: createDateString) else {
                print("⚠️ Failed to parse user profile for userId: \(userId)")
                completion(nil) // Return nil if parsing fails
                return
            }
            
            let userProfile = UserProfile(
                accountName: accountName,
                name: name,
                createDate: createDate,
                status: status,
                activeDevices: activeDevices,
                maxDevices: maxDevices,
                packageType: packageType,
                id: id //snapshot.key.toInt() // Assuming you want to store the key as an id.
            )
            completion(userProfile) // Return the parsed user profile
        }
    }
}
