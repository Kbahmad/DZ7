//
//  UserProfileM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import PhotosUI
import UIKit
import CoreTransferable

@MainActor
class UserProfileM: ObservableObject {
    // MARK: - User Details
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var surname: String = ""
    @Published var tel: String = ""
    @Published var tg: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    
    // MARK: - User Image State
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }

    @Published private(set) var imageState: ImageState = .empty
    
    // Photo picked item
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    
    /// What if transfer image failed
    enum TransferError: Error {
        case importFailed
    }
    
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                UserDefaults.standard.set(data, forKey: "Avatar")
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            }
        }
        
    }
    
    
    // All key values in UserDefaults
    let keyValues = ["FirstName", "LastName", "Surname", "Email", "TG", "Tel", "Nickname"]
    
    
    // Save all fileds in UserDefaults
    public func saveInUserDefaults() {
        // print("Save")
        for key in keyValues {
            switch key {
            case "FirstName":
                UserDefaults.standard.set(firstName, forKey: key)
            case "LastName":
                UserDefaults.standard.set(lastName, forKey: key)
            case "Surname":
                UserDefaults.standard.set(surname, forKey: key)
            case "Email":
                UserDefaults.standard.set(email, forKey: key)
            case "TG":
                UserDefaults.standard.set(tg, forKey: key)
            case "Tel":
                UserDefaults.standard.set(tel, forKey: key)
            case "Nickname":
                UserDefaults.standard.set(nickname, forKey: key)
            default:
                print("Unknown value")
            }
        }
    }

    
    // Set image state for restore data from UserDefaults
    public func setImageStateSuccess(image: Image) {
        self.imageState = .success(image)
    }
    
    
    // MARK: - Private Methods
    
    // Loading state after go to success or failure
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
