//
//  UserDataModal.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import Foundation

// MARK: - UserDataModalElement
struct UserDataModalElement: Codable {
    let heartRate, breathRate, o2: Int?
    let bloodPressure: Bp?
    let recovery, sleepscore, time: Int?
    let bp: Bp?

    enum CodingKeys: String, CodingKey {
        case heartRate = "HeartRate"
        case breathRate = "BreathRate"
        case o2 = "O2"
        case bloodPressure = "Blood Pressure"
        case recovery = "Recovery"
        case sleepscore, time
        case bp = "BP"
    }
}

// MARK: - Bp
struct Bp: Codable {
    let systole, diastole: Int?

    enum CodingKeys: String, CodingKey {
        case systole = "Systole"
        case diastole = "Diastole"
    }
}

typealias UserDataModal = [UserDataModalElement]
