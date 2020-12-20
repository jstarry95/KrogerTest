//
//  AuthResponse.swift
//  KrogerTest
//
//  Created by Jacob Starry on 12/12/20.
//

import Foundation

struct AuthResponse: Codable {
    let expires_in: Int?
    let access_token: String?
    let token_type: String?
}
