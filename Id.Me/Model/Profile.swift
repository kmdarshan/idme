//
//  Profile.swift
//  Id.Me
//
//  Created by darshan on 3/10/22.
//

import Foundation
struct Profile: Decodable {
    var name: String
    var username: String
    var fullname: String
    var phoneNumber: String
    var registration: String
    var image: String

    enum CodingKeys: String, CodingKey {
        case name
        case username = "user_name"
        case fullname = "full_name"
        case phoneNumber = "phone_number"
        case registration
        case image
    }
}
