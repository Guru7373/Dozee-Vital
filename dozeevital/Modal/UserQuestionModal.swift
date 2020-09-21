//
//  UserQuestionModal.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import Foundation

// MARK: - UserQuestionModal
struct UserQuestionModal: Codable {
    let question, greeting: String
    var answers: [String]

    enum CodingKeys: String, CodingKey {
        case question = "Question"
        case greeting = "Greeting"
        case answers = "Answers"
    }
}
