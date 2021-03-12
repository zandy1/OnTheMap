//
//  CreateStudentResponse.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/5/21.
//

import Foundation

struct CreateStudentResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
