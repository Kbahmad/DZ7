//
//  LoginS.swift
//  AuthSUI8
//  Created by brfsu on 13.03.2024.
//
import SwiftUI

struct SigninS: View {
    @EnvironmentObject var vm: MainVM
    
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).onAppear {
                        username = "User1"
                        password = "Password1!"
                    }
                
                PasswordTextFieldV("Password", text: $password, isSecure: !isPasswordVisible)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay {
                        HStack {
                            Spacer()
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                
                Button {
                    let body: [String: Any] = [
                        "username": username,
                        "password": password
                    ]
                    vm.postRequest(endpoint: "signin", body: body, callback: { response in
                        DispatchQueue.main.async {
                            if response.id >= 0 { // user found
                                UserDefaults.standard.setValue(response.token, forKey: "token")
                                UserDefaults.standard.synchronize()
                                vm.navigationState = .Main
                                vm.errorState = .Success(message: "You are signed in successfully.")
                            } else { // response.id == -1 // user not found
                                vm.navigationState = .Signin
                                vm.errorState = .Error(message: response.token)
                            }
                        }
                    })
                } label: {
                    Text("Login")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(10)
                }
                
                // go back
                Button {
                    vm.navigationState = .AuthMenu
                } label: {
                    Text("Back")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onTapGesture {
            endEditing()
        }
    }


    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}
