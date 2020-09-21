//
//  APIManager.swift
//  dozeevital
//
//  Created by Guru Raj R on 20/09/20.
//

import Foundation

struct URLs {
    static let baseURL = "https://6c829492-4c01-4a59-bbb3-801076aa173d.mock.pstmn.io/api/user"
//    static let baseURLNew = "https://f2a8b123-adbb-4c6a-beba-f3d3d42eea86.mock.pstmn.io/api/user"
    static let userDetail = URL(string: "\(baseURL)/details/")
    static let userData = URL(string: "\(baseURL)/data/")
    static let userQuestion = URL(string: "\(baseURL)/question/")
}

class APIManager {
    let timeOutInterval = TimeInterval(30)
    
    var userDetailProtocol: UserDetailProtocol?
    var userDataProtocol: UserDataProtocol?
    var userQuestionProtocol: UserQuestionProtocol?
    
    func getUserDetails() {
        var request = URLRequest(url: URLs.userDetail!)
        request.httpMethod = "GET"
        request.timeoutInterval = timeOutInterval
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else { return }
            if let error = error {
                self.userDetailProtocol?.userDetailError(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let userDetail = try? JSONDecoder().decode(UserDetailsModal.self, from: jsonData) {
                        self.userDetailProtocol?.userDetailResponse(userDetail)
                    } else {
                        self.userDetailProtocol?.userDetailError("Data Error")
                    }
                } else {
                    self.userDetailProtocol?.userDetailError("\(response.statusCode)")
                }
            } else {
                self.userDetailProtocol?.userDetailError("No Response.")
            }
        }.resume()
    }
    
    func getUserData() {
        var request = URLRequest(url: URLs.userData!)
        request.httpMethod = "GET"
        request.timeoutInterval = timeOutInterval
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else { return }
            if let error = error {
                self.userDataProtocol?.userDataError(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let userData = try? JSONDecoder().decode(UserDataModal.self, from: jsonData) {
                        self.userDataProtocol?.userDataResponse(userData)
                    } else {
                        self.userDataProtocol?.userDataError("Data Error")
                    }
                } else {
                    self.userDataProtocol?.userDataError("\(response.statusCode)")
                }
            } else {
                self.userDataProtocol?.userDataError("No Response.")
            }
        }.resume()
    }
    
    func getUserQuestions() {
        var request = URLRequest(url: URLs.userQuestion!)
        request.httpMethod = "GET"
        request.timeoutInterval = timeOutInterval
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else { return }
            if let error = error {
                self.userQuestionProtocol?.userQuestionError(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let userQuestion = try? JSONDecoder().decode(UserQuestionModal.self, from: jsonData) {
                        self.userQuestionProtocol?.userQuestionResponse(userQuestion)
                    } else {
                        self.userQuestionProtocol?.userQuestionError("Data Error")
                    }
                } else {
                    self.userQuestionProtocol?.userQuestionError("\(response.statusCode)")
                }
            } else {
                self.userQuestionProtocol?.userQuestionError("No Response.")
            }
        }.resume()
    }
}
