
import SwiftUI
import PhotosUI

struct ProfileImageV: View
{
    let imageState: UserProfileM.ImageState

    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading: // (let progress):
            ProgressView()
        case .empty:
            Image("Avatar.png")
                .resizable()
                .scaledToFit()
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure: // (let error):
            Image("Warning.png")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}
struct UserProfileS_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileS()
            .environmentObject(MainVM()) // If your app uses an environment object
    }
}
