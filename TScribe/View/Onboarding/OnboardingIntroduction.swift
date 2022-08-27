//
//  OnboardingIntroduction.swift
//  TScribe
//
//  Created by Alessio Rubicini on 14/06/21.
//

import SwiftUI

struct OnboardingIntroduction: View {
    var body: some View {
        
        VStack {
            // App description
            VStack(alignment: .leading) {
                
                HStack {
                    Text("onboarding.title")
                        .fontWeight(.bold)
                    .font(.largeTitle)
                    Spacer()
                }.padding(.horizontal, 15).padding(.top, 40)
                    
                
                Text("onboarding.description")
                    .fontWeight(.regular)
                    .padding(15)
                    .multilineTextAlignment(.leading)
                
            }
            
            // App features
            VStack(alignment: .leading) {
                OnboardingDetail(image: "waveform.and.mic", color: .orange, title: "onboarding.feature1.title", description: "onboarding.feature1")
                    .padding(.vertical)
                
                OnboardingDetail(image: "person.circle.fill", color: .blue, title: "onboarding.feature2.title", description: "onboarding.feature2")
                    .padding(.vertical)
                
                OnboardingDetail(image: "hand.raised.slash.fill", color: .green, title: "onboarding.feature3.title", description: "onboarding.feature3")
                    .padding(.vertical)
            }
            
            Spacer()
        }
        
        
    }
}

struct OnboardingIntroduction_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntroduction()
    }
}
