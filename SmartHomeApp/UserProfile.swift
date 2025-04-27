//
//  UserProfile.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    var id: Int // Use the id provided in the JSON
    var accountName: String
    var name: String
    var createDate: Date // Store the creation date as a Date
    var status: String
    var activeDevices: Int?
    var maxDevices: Int?
    var packageType: String?
}
