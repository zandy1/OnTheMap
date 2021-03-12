//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/4/21.
//

import Foundation
struct LoginRequest: Codable {
    let udacity: String
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case udacity
        case username
        case password
    }
}
