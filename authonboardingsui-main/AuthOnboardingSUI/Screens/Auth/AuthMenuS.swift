//
//  AuthMenu.swift
//  AuthOnboardingSUI
//  Created by B.RF Group on 17.01.2025.
//
import SwiftUI

struct AuthMenuS: View {
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        VStack {
            // Sign in button
            Button {
                vm.navigationState = .Signin
            } label: {
                Text("Sign in")
                    .font(.system(size: 25, weight: .bold))
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(.green)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                    }
            }
            
            // Reset password button
            Button {
                vm.navigationState = .Reset
            } label: {
                Text("Reset password")
                    .font(.system(size: 25, weight: .bold))
                    .frame(width: 200, height: 30).padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                    }
            }
            
            // Sign up button
            Button {
                vm.navigationState = .Signup
            } label: {
                Text("Sign up")
                    .font(.system(size: 25, weight: .bold))
                    .frame(width: 200, height: 30).padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                    }
            }
            
            // Delete user account button
            Button {
                vm.navigationState = .Drop
            } label: {
                Text("Delete account")
                    .font(.system(size: 25, weight: .bold))
                    .frame(width: 200, height: 30).padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                    }
            }
        }
    }
}
