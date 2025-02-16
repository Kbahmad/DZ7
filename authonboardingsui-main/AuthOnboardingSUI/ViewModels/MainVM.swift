//
//  AuthVM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

class MainVM: ObservableObject
{
    private let api = "http://127.0.0.1:7000/api/auth"
    private var serverResponse = RegLogResponse(id: -1, token: "Undefined.")
    
    @Published var navigationState: NavigationState = .Onboarding
    @Published var errorState: ErrorState = .None
    
    @Published var onbordingData = OnbordingM.onbordingData
    
    @Published var loginCounter = 0
    @Published var token = ""
    @Published var data = ""
    @Published var users: [UserM] = []
    
    init() {
        if !UserDefaults.standard.bool(forKey: "onboardingDone") { self.navigationState = .Onboarding
        } else {
            if let token = UserDefaults.standard.string(forKey: "token") {
                self.token = token
                if token.count > 0 {
                    self.navigationState = .Main // .AuthMenu
                } else {
                    navigationState = .AuthMenu
                }
            } else {
                navigationState = .AuthMenu
            }
        }
    }
    
    // Password validation function
    private func validatePassword(password: String) -> Bool {
        let control = #"(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "])"#
        
        if password.range(of: control, options: .regularExpression) != nil { return true }
        return false
    }
    
    
    // Server post request // for endpoints: signin, signup, drop and reset password
    func postRequest(endpoint: String = "signin", body: [String: Any], callback: @escaping (RegLogResponse) -> Void, _ requestType: String = "POST") {
        self.token = ""
        let url = URL(string: "\(api)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                }
                return
            }
            
            guard let datas = data else {
                print("No data received from server")
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received from server")
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RegLogResponse.self, from: datas)
                
                if response.id < 0 {
                    DispatchQueue.main.async {
                        self.errorState = .Error(message: response.token)
                    }
                    return
                } else {
                    // token received
                    DispatchQueue.main.async {
                        // self.errorState = .Success(message: authResponse.token)
                        UserDefaults.standard.setValue(response.token, forKey: "token")
                        self.token = response.token
                        callback(response)
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                }
                
            }
        }.resume()
    }
    
    
    // Server get request // for endpoints: data, check
    func getRequest(endpoint: String = "data", body: [String: Any] = [:], token: String = "", requestType: String = "GET", completion: @escaping (RegLogResponse) -> Void) {
//        self.token = ""
        let url = URL(string: "\(api)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if !body.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    // self.errorState = .Error(message: err.localizedDescription)
                    completion(RegLogResponse(id: -1, token: err.localizedDescription))
                }
                return
            }
            guard let datas = data else {
                DispatchQueue.main.async {
                    // self.errorState = .Error(message: "No data received from server.")
                    completion(RegLogResponse(id: -1, token: "No data received from server."))
                }
                return
            }
            do { // data received - let's decode it and read
                let response = try JSONDecoder().decode(RegLogResponse.self, from: datas)
                DispatchQueue.main.async {
                    // self.errorState = response.id == 0 ? .Success(message: response.token) : .Error(message: response.token)
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    // self.errorState = .Error(message: error.localizedDescription)
                    completion(RegLogResponse(id: -1, token: error.localizedDescription))
                }
            }
        }.resume()
    }
    
    
    // Get users from server
    func getUsers(token: String, completion: @escaping ([UserM]) -> Void) {
        let url = URL(string: "http://127.0.0.1:7000/api/auth/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: err.localizedDescription)
                    self.users = []
                    completion([])
                }
                return
            }
            guard let datas = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received from server.")
                    self.users = []
                    completion([])
                }
                return
            }
            do {
                if datas.count > 0 { // Data recieved well.
                    let us = try JSONDecoder().decode([UserM].self, from: datas)
                    DispatchQueue.main.async {
                        self.errorState = .Success(message: "Successful users data extraction from server.")
                        self.users = us
                        completion(us)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorState = .Error(message: "There are no users.")
                        self.users = []
                        completion([])
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    self.users = []
                    completion([])
                }
            }
        }.resume()
    }
}
