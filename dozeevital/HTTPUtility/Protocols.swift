//
//  Protocols.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import Foundation

protocol UserDetailProtocol {
    func userDetailResponse(_ response: UserDetailsModal)
    func userDetailError(_ error: String)
}

protocol UserDataProtocol {
    func userDataResponse(_ response: UserDataModal)
    func userDataError(_ error: String)
}

protocol UserQuestionProtocol {
    func userQuestionResponse(_ response: UserQuestionModal)
    func userQuestionError(_ error: String)
}
