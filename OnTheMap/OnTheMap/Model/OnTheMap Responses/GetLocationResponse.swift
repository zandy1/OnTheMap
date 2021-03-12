//
//  GetLocationResponse.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/4/21.
//

import Foundation

struct GetLocationResponse: Codable {
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
