//
//  NewStudentRequest.swift
//  On The Map
//
//  Created by Anna Solovyeva on 18/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import Foundation

struct NewStudentRequest: Codable {
    let mediaURL: String
    let location: String
}
