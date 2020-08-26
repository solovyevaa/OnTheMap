//
//  NewSessionResponse.swift
//  On The Map
//
//  Created by Anna Solovyeva on 18/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import Foundation

struct NewSessionResponse: Codable {
    let account: Account
    let session: Session
}
