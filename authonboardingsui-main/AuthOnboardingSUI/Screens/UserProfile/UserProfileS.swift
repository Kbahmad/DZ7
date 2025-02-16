//
//  UserProfileS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct UserProfileS: View
{
    @StateObject var vm = UserProfileM()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $vm.nickname)
                    TextField("Email", text: $vm.email)
                }

                Section {
                    HStack {
                        ChangableAvatarV(vm: vm)
                        VStack {
                            TextField("First name", text: $vm.firstName)
                            TextField("Last name", text: $vm.lastName)
                            TextField("Surname", text: $vm.surname)
                        }.padding(.leading)
                    }
                }
                
                Section {
                    TextField("Telegramm", text: $vm.tg)
                    TextField("Phone", text: $vm.tel)
                }

                Section {
                    Button(action: {
                        vm.saveInUserDefaults()
                    }, label: {
                        Text("Save")
                    })
                    Button(action: {
                        restore(viewModel: vm)
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
            .navigationTitle("User profile")
        }
        .cornerRadius(15)
        .background(.white)
        .padding(0)
        .onAppear {
            restore(viewModel: vm)
        }
        //.navigationBarTitle("User Profile", displayMode: .inline)
    }
}


@MainActor
func restore(viewModel: UserProfileM) {
    let data = UserDefaults.standard.data(forKey: "Avatar") ?? UIImage(named: "Avatar")!.jpegData(compressionQuality: 1)! // Warning
    let image = UIImage(data: data)!
    viewModel.setImageStateSuccess(image: Image(uiImage: image))
    
    for key in viewModel.keyValues {
        switch key {
        case "FirstName":
            viewModel.firstName = UserDefaults.standard.string(forKey: key) ?? ""
        case "LastName":
            viewModel.lastName = UserDefaults.standard.string(forKey: key) ?? ""
        case "Surname":
            viewModel.surname = UserDefaults.standard.string(forKey: key) ?? ""
        case "Email":
            viewModel.email = UserDefaults.standard.string(forKey: key) ?? ""
        case "TG":
            viewModel.tg = UserDefaults.standard.string(forKey: key) ?? ""
        case "Tel":
            viewModel.tel = UserDefaults.standard.string(forKey: key) ?? ""
        case "Nickname":
            viewModel.nickname = UserDefaults.standard.string(forKey: key) ?? ""
        default:
            print("Unknown value")
        }
    }
}
