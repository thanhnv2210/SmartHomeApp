//
//  ContentView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State private var devices: [Device] = []

    var body: some View {
        NavigationView {
            List(devices) { device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    HStack {
                        Text(device.name)
                        Spacer()
                        Text(device.status)
                            .foregroundColor(device.status == "ON" ? .green : .red)
                    }
                }
            }
            .navigationTitle("Smart Home Devices")
            .onAppear {
                loadDeviceData()
            }
        }
    }

    private func loadDeviceData() {
        let deviceService = DeviceService()
        deviceService.loadDevices { fetchedDevices in
            devices = fetchedDevices
            print(devices)
        }
    }
}
