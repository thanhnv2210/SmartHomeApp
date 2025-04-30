//
//  DeviceSearchView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 30/4/25.
//

import SwiftUI

struct DeviceSearchView: View {
    @StateObject private var bluetoothManager = BluetoothManager() // Create an instance of BluetoothManager

    var body: some View {
        VStack {
            Text("Searching for Devices...")
                .font(.headline)
                .padding()

            // List to show discovered devices
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                HStack {
                    Text(peripheral.name ?? "Unknown device") // Display device name
                    Spacer()
                    Button(action: {
                        bluetoothManager.connect(to: peripheral) // Connect when "Pair" is tapped
                    }) {
                        Text("Pair")
                            .foregroundColor(.blue)
                    }
                }
            }

            Button("Start Discovery") {
                bluetoothManager.startScanning() // Start scanning for devices
            }
            .padding()
        }
        .navigationTitle("Device Search")
        .onAppear {
            bluetoothManager.startScanning() // Start discovering devices when the view appears
        }
        .onDisappear {
            bluetoothManager.stopScanning() // Stop scanning when leaving the view
        }
    }
}
