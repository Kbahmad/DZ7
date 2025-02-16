//
//  UserM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

struct UserM: Codable, Identifiable
{
    let id: Int
    let username: String
    let password: String
    let secretResponse: String
    let token: String
}
