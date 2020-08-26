//
//  Results.swift
//  On The Map
//
//  Created by Anna Solovyeva on 12/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import Foundation

struct Results: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}
