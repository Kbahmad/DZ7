//
//  OnboardingStepS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct OnboardingStepV: View
{
    let data: OnbordingM
    
    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .padding()

            Text(data.heading)
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.bold)
                .padding(.vertical)
            
            Text(data.text)
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
