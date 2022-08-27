//
//  OnboardingView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 14/06/21.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - View properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var isFirstLaunch: Bool
    
    @State private var onboardingPage = 1
    
    // MARK: - View body
    
    var body: some View {
        VStack {
            TabView(selection: $onboardingPage) {
                
                OnboardingIntroduction().tag(1)
                
                OnboardingSetup(isFirstLaunch: $isFirstLaunch).tag(2)
                
            }
            .tabViewStyle(.page)
            
            HStack {
                
                Button(action: {
                    withAnimation {
                        self.onboardingPage -= 1
                    }
                }, label: {
                    Image(systemName: "arrow.backward.circle.fill").font(.system(size: 40))
                }).disabled(onboardingPage == 1)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.onboardingPage += 1
                    }
                }, label: {
                    Image(systemName: "arrow.forward.circle.fill").font(.system(size: 40))
                }).disabled(onboardingPage == 2).font(.largeTitle)
                
            }.padding().padding(.horizontal, 30)
            
        }
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isFirstLaunch: .constant(false))
    }
}
