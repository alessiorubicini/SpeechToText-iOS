//
//  TScribe.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI

@main
struct TScribe: App {
    
    // MARK: - Properties
    
    @StateObject private var data = AppData()
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true

    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            
            TranscriptionsList(data: self.data)
            
                .sheet(isPresented: $isFirstLaunch) {
                    OnboardingView(isFirstLaunch: $isFirstLaunch)
                }
            
                .onAppear {
                    self.data.load()
                }
            
        }
    }
}
