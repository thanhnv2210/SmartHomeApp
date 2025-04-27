//
//  ProfileCreationView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 28/4/25.
//

import SwiftUI
import Firebase

struct ProfileCreationView: View {
    @State private var accountName: String = ""
    @State private var name: String = ""
    @State private var packageType: String = "STANDARD" // Default package type
    @State private var errorMessage: String = ""
    @State private var isProfileCreated: Bool = false
    private var userId: String

    init(userId: String) {
        self.userId = userId
    }

    var body: some View {
        Form {
            Section(header: Text("Create User Profile")) {
                TextField("Account Name", text: $accountName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Package Type", selection: $packageType) {
                    Text("STANDARD").tag("STANDARD")
                    Text("PREMIUM").tag("PREMIUM")
                }

                Button(action: createProfile) {
                    Text("Create Profile")
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                if isProfileCreated {
                    Text("Profile created successfully!")
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Create Profile")
    }

    private func createProfile() {
        let userProfile = UserProfile(
            id: userId,
            accountName: accountName,
            name: name,
            createDate: Date(),
            status: "ACTIVE",
            activeDevices: 0,
            maxDevices: 10,
            packageType: packageType,
        )

        FirebaseManager.shared.saveUserProfile(userProfile: userProfile) { success in
            if success {
                isProfileCreated = true
                // You might want to navigate back or update the main view accordingly
            } else {
                errorMessage = "Failed to create profile."
            }
        }
    }
}
