//
//  OnboardingSetup.swift
//  TScribe
//
//  Created by Alessio Rubicini on 14/06/21.
//

import SwiftUI
import Foundation
import AVFAudio
import AVFoundation
import Speech

struct OnboardingSetup: View {
    
    // MARK: - View properties
    
    @Binding var isFirstLaunch: Bool
    
    @State private var speechRecPermit: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var microphonePermit: AVAudioSession.RecordPermission = .undetermined
    
    // MARK: - View body
    
    var body: some View {
        VStack {
            
            Image(systemName: "shield.fill").font(.system(size: 100)).foregroundColor(.accentColor).shadow(radius: 10)
            
            Text("onboarding.permits").padding()
            
            Button(action: {
                self.askMicrophonePermission()
            }, label: {
                Label("onboarding.microphone", systemImage: "mic.fill").frame(maxWidth: 300)
                    .foregroundColor(microphonePermit == .denied ? .red : .primary)
                
            }).buttonStyle(.bordered)
                .buttonStyle(.borderedProminent).controlSize(.large)
                .disabled(microphonePermit == .granted).padding(.vertical, 20)
            
            Button(action: {
                self.askSpeechRecognitionPermission()
            }, label: {
                Label("onboarding.speechRecognition", systemImage: "waveform.and.mic").frame(maxWidth: 300)
                    .foregroundColor(speechRecPermit == .denied ? .red : .primary)
                
            }).buttonStyle(.bordered)
                .buttonStyle(.borderedProminent).controlSize(.large)
                .disabled(speechRecPermit == .authorized).padding(.vertical, 20)
            
            
            Button(action: {
                
                // Set onboarding value
                self.isFirstLaunch = false
                
            }, label: {
                Text("onboarding.button").fontWeight(.semibold).frame(maxWidth: 300)
            }).buttonStyle(.borderedProminent).controlSize(.large)
                .padding(.vertical, 20)
            
        }
    }
    
    private func askMicrophonePermission() {
        
        let session = AVAudioSession.sharedInstance()
        
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    self.microphonePermit = .granted
                } else {
                    self.microphonePermit = .denied
                }
            })
            
        }
        
    }
    
    private func askSpeechRecognitionPermission() {
        // Make the authorization request
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                self.speechRecPermit = authStatus
            }
        }
    }
    
}

struct OnboardingSetup_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSetup(isFirstLaunch: .constant(false))
            
    }
}
