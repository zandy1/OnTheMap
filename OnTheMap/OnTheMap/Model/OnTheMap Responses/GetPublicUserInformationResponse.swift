//
//  GetPublicUserInformationResponse.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/5/21.
//

import Foundation

struct GetPublicUserInformationResponse: Codable {
    let user: User
}
    struct User: Codable {
        let firstName: String
        let lastName: String
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
        }
    }
