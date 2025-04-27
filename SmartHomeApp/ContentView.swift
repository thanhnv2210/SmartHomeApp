//
//  ContentView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var deviceInfo: [String: Any] = [:]
    @State private var statusMessage: String = ""

    var body: some View {
        VStack {
            Text("Smart Home Device Info")
                .font(.headline)
                .padding()

            // Display device info
            Text("Device Status: \(deviceInfo["status"] as? String ?? "N/A")")
            Text("Last Watered: \(deviceInfo["last_watered"] as? String ?? "N/A")")

            Button(action: {
                let firebaseManager = FirebaseManager()
                firebaseManager.readDeviceInfo(deviceId: "device1") { info in
                    if let info = info {
                        deviceInfo = info
                        statusMessage = "Device info loaded."
                    } else {
                        statusMessage = "Failed to load device info."
                    }
                }
            }) {
                Text("Load Device Info")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                let firebaseManager = FirebaseManager()
                firebaseManager.updateDeviceStatus(deviceId: "device1", status: "ON") { error in
                    if let error = error {
                        statusMessage = "Failed to update status: \(error.localizedDescription)"
                    } else {
                        statusMessage = "Device status updated to ON."
                    }
                }
            }) {
                Text("Turn Device ON")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Text(statusMessage)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
