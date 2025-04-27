//
//  UserProfile.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation

struct UserProfile: Identifiable {
    var id: Int // Use the id provided in the JSON
    var accountName: String
    var name: String
    var createDate: Date // Store the creation date as a Date
    var status: String
    var activeDevices: Int
    var maxDevices: Int
    var packageType: String

    // Initializer for the UserProfile
    init(accountName: String, name: String, createDate: Date, status: String, activeDevices: Int, maxDevices: Int, packageType: String, id: Int) {
        self.accountName = accountName
        self.name = name
        self.createDate = createDate
        self.status = status
        self.activeDevices = activeDevices
        self.maxDevices = maxDevices
        self.packageType = packageType
        self.id = id
    }
}
