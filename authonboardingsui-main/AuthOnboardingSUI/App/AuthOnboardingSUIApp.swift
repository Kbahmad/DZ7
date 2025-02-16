//
//  AuthOnboardingSUIApp.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

@main
struct AuthOnboardingSUIApp: App
{
    static let vm = MainVM()
    
    var body: some Scene {
        WindowGroup {
            ScreenSwitcherS()
                    .environmentObject(Self.vm)
        }
    }
}
