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
                        pairDevice(deviceName) // Pair device on button click
                    }) {
                        Text("Pair")
                            .foregroundColor(.blue)
                    }
                }
            }

            // Optional: Add a button to simulate discovering devices
            Button("Start Discovery") {
                startDeviceDiscovery() // Start the discovery process
            }
            .padding()
        }
        .navigationTitle("Device Search")
        .onAppear {
            startDeviceDiscovery() // Start searching for devices when the view appears
        }
    }

    private func startDeviceDiscovery() {
        // Simulate discovering devices. You can customize this list as needed.
        // This could include existing device names like "AirPods".
        discoveredDevices = ["AirPods", "Device 1", "Device 2", "Device 3"] // Example devices
    }

    private func pairDevice(_ deviceName: String) {
        if deviceName == "AirPods" {
            // Simulate pairing with AirPods
            print("Pairing with device: \(deviceName)")
            // Indicate the pairing successful
            isPairing = true
            
            // Add additional logic here to simulate pairing process (e.g., delay, UI updates)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a 2-second pairing process
                print("\(deviceName) paired successfully!")
                isPairing = false
            }
        } else {
            // Logic for pairing other devices (if necessary)
            print("Pairing with other device: \(deviceName)")
            isPairing = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a 2-second pairing process
                print("\(deviceName) paired successfully!")
                isPairing = false
            }
        }
    }
}

#Preview {
    DeviceSearchView()
}
