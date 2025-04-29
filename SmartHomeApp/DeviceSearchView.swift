//
//  DeviceSearchView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 30/4/25.
//

import SwiftUI

struct DeviceSearchView: View {
    @State private var discoveredDevices: [String] = [] // Array to hold discovered device names
    @State private var isPairing: Bool = false // To indicate if pairing is in progress
    @State private var selectedDevice: String? = nil // To hold the currently selected device

    var body: some View {
        VStack {
            Text("Searching for Devices...")
                .font(.headline)
                .padding()

            // List to show discovered devices
            List(discoveredDevices, id: \.self) { deviceName in
                HStack {
                    Text(deviceName)
                    Spacer()
                    Button(action: {
                        pairDevice(deviceName)
                    }) {
                        Text("Pair")
                            .foregroundColor(.blue)
                    }
                }
            }

            // Optional: Add a button to manually trigger device discovery
            Button("Start Discovery") {
                startDeviceDiscovery()
            }
            .padding()
        }
        .navigationTitle("Device Search")
        .onAppear {
            startDeviceDiscovery() // Start searching for devices when the view appears
        }
    }

    private func startDeviceDiscovery() {
        // Simulate discovering devices; replace with real discovery logic.
        discoveredDevices = ["Device 1", "Device 2", "Device 3"] // Replace with actual discovery results.
    }

    private func pairDevice(_ deviceName: String) {
        // Logic to pair the selected device with the user's account.
        // This could include updating the device's association in Firebase.
        print("Pairing with device: \(deviceName)")
        isPairing = true
        // Implement actual pairing logic here, and reset the variable after completion.
    }
}

#Preview {
    DeviceSearchView()
}
