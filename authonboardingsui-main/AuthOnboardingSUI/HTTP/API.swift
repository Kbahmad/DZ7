//
//  API.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

class API: NSObject
{
    static func loadData(url: String, completion: @escaping (RegLogResponse) -> ()) {
        guard let url = URL(string: url) else {
            print("Incorrect url.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let regLogResponse = try JSONDecoder().decode(RegLogResponse.self, from: data!)
                DispatchQueue.main.async {
                    completion(regLogResponse)
                }
            } catch {
                print("Decoding error.")
            }
        }
        .resume()
    }
}
