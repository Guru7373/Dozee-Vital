//
//  UserDetailsModal.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import Foundation

// MARK: - UserDetailsModal
struct UserDetailsModal: Codable {
    let name: String
    let phone: Phone
    let dob: String
}

// MARK: - Phone
struct Phone: Codable {
    let number, countryCode: String
}
