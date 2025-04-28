//
//  ContentView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State private var userId: String = ""
    @State private var userProfile: UserProfile? // Store user profile data
    @State private var devices: [Device] = []
    @State private var showingProfileCreation = false
    private let firebaseManager = FirebaseManager() // DeviceService instance

    var body: some View {
        NavigationView {
            VStack {
                if let userProfile = userProfile {
                    Text("Welcome, \(userProfile.name)")
                    Text("Status: \(userProfile.status)")
                    
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
                } else {
                    NavigationLink("Login", destination: LoginView(onLoginSuccess: { uid in
                        userId = uid // Capture the user's UID
                        loadUserProfile(userId: uid) // Load the user profile
                    })) // Pass the callback
                }
            }
            .navigationTitle("Smart Home Devices")
            .onAppear {//run as init function
                if !ConfigManager.shared.isAuthenticationRequired {
                    // Load user profile using a test ID if authentication is not required.
                    userId = ConfigManager.shared.appTestId
                    print("loading test user profile with ID: \(userId)")
                    loadUserProfile(userId: userId)
                }
            }
        }
        .sheet(isPresented: $showingProfileCreation) {
            ProfileCreationView(userId: userId) // Pass the userId to the profile creation view
        }
    }
    
    
    private func loadUserProfile(userId: String) {
        print("Loading user profile for \(userId)")
        FirebaseManager.shared.loadUserProfile(userId: userId) { profile in
            self.userProfile = profile
            if profile != nil {
                loadDeviceData(userId: userId) // Load devices only after the user profile is successfully loaded
            } else {
                print( "No user profile Found!")
                // If no profile found, navigate to profile creation
                navigateToProfileCreation()
            }
        }
    }

    private func loadDeviceData(userId: String) {
        FirebaseManager.shared.loadDevices(userId: userId) { fetchedDevices in
            devices = fetchedDevices
            print(devices)
        }
    }
    
    private func navigateToProfileCreation() {
        showingProfileCreation = true
    }
}
