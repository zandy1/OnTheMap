//
//  OnTheMapResponse.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/6/21.
//

import Foundation

struct OnTheMapResponse: Codable {
    
    let status: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case error
    }
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
