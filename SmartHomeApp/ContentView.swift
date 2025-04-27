//
//  ContentView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State private var userProfile: UserProfile? // Store user profile data
    @State private var devices: [Device] = []
    private let firebaseManager = FirebaseManager() // DeviceService instance

    var body: some View {
        NavigationView {
            VStack {
                if let userProfile = userProfile {
                    Text("Welcome, \(userProfile.name)")
                    Text("Status: \(userProfile.status)")
                } else {
                    Text("Loading user profile...")
                }
                
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
            }
            .navigationTitle("Smart Home Devices")
            .onAppear {
                loadUserProfile()
                loadDeviceData()
            }
        }
    }
    
    private func loadUserProfile() {
        FirebaseManager.shared.loadUserProfile(userId: "thanh001") { profile in
            self.userProfile = profile
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
