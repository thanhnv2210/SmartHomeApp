//
//  FirebaseManager.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    private var ref: DatabaseReference!

    init() {
        ref = Database.database().reference()
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
}
