//
//  DataV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct DataV: View
{
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                Text(vm.data)
                    .foregroundColor(.green)
                Spacer()
                //                ForEach(vm.users) { user in
                //                    NavigationLink(destination: UserS(user: user)) {
                //                        Text(user.username)
                //                    }
                //                }
                
                List(vm.users) { user in
                    NavigationLink(destination: UserS(user: user)) {
                        Text(user.username)
                    }
                }
                .navigationBarTitle("Users") //, displayMode: .inline)
                .navigationBarItems(leading:
                                        HStack {
                    NavigationLink(destination: AboutS(model: AboutTeamM.mock)) {
                        Text("About")
                    }
                }, trailing:
                                        VStack {
                    NavigationLink(destination: UserProfileS()) {
                        Text("Profile")
                    }
                })
            }
            .onAppear() {
                vm.getRequest(endpoint: "data", body: [:], token: vm.token, requestType: "GET") { response in
                    DispatchQueue.main.async {
                        if response.id == 0  {
                            // vm.errorState = .Success(message: "Data received from server successfully.")
                            vm.data = response.token
                        } else { // response.id == -1 // error
                            vm.errorState = .Error(message: response.token)
                            vm.navigationState = .AuthMenu
                        }
                    }
                }
                
                vm.getUsers(token: vm.token, completion: { users in
                    DispatchQueue.main.async {
                        vm.users = users
                    }
                })
            }
        }
    }
}
