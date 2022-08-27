//
//  RecordView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI
import Foundation
import AVFAudio
import AVFoundation
import Speech

struct RecordView: View {
    
    // MARK: - View properties
    
    @ObservedObject var data: AppData
    @Binding var record: Transcription
    
    @Environment(\.presentationMode) var presentationMode
    private let speechRecognizer = SpeechRecognizer()
    
    @State private var alert = (false, "", "")
    @State private var status: RecordingStatus = .stopped
    @State private var transcription = "Transcription goes here"
    
    // MARK: - View body
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("newRegistration.input.title")) {
                    TextField("newRegistration.input.title", text: $record.title)
                }
                    
                Section(header: Text("newRegistration.transcription")) {
                    HStack {
                        Spacer()
                        Group {
                            Image(systemName: status.icon)
                            Text(LocalizedStringKey(status.rawValue))
                        }.font(.headline)
                        Spacer()
                    }.foregroundColor(status.color)
                    
                    TextEditor(text: $record.text).multilineTextAlignment(.leading)
                        .frame(height: 350)
                }
            }
            
            .onChange(of: transcription) { newText in
                if status == .recording {
                    record.text = newText
                }
            }
            
            .toolbar {
                
                ToolbarItemGroup(placement: .bottomBar) {
                    
                    Button(action: self.startRecording, label: {
                        Image(systemName: status == .paused ? "play.fill" : "record.circle.fill")
                    }).disabled(status == .recording)
                    
                    Spacer()
                    
                    Button(action: self.pauseRecording, label: {
                        Image(systemName: "pause.fill")
                    }).disabled(status != .recording)
                    
                    Spacer()
                    
                    Button(action: self.stopRecording, label: {
                        Image(systemName: "stop.fill").foregroundColor(status == .recording ? .red : .secondary)
                    }).disabled(status != .recording)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .cancel,  action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("newRegistration.cancel").fontWeight(.semibold)
                    }).disabled(status == .recording)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: self.saveRecording, label: {
                        Text("newRegistration.save").fontWeight(.semibold)
                    }).disabled(status == .recording || record.title == "")
                }
                
            }
            
            .navigationTitle(record.title.isEmpty ? Text(Date(), style: .date) : Text(record.title))
            
        }
        
        .alert(isPresented: $alert.0) {
            Alert (title: Text(LocalizedStringKey(self.alert.1)),
                   message: Text(LocalizedStringKey(self.alert.2)),
                   primaryButton: .default(Text("settings.title"), action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }),
                   secondaryButton: .default(Text("alert.close")))
        }
        
    }
    
    // MARK: - Functions
    
    private func saveRecording() {
        // Add new transcription
        if !data.transcriptions.contains(where: {$0.id == record.id}) {
            self.data.transcriptions.append(self.record)
        }
        
        // Save data
        self.data.save()
        
        // Generate haptic feedback
        notificationFeedback(type: .success)
        
        // Dismiss sheet
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func startRecording() {
        // Check microphone permit
        if AVAudioSession.sharedInstance().recordPermission != .granted {
            self.alert.1 = "alert.noMic.title"
            self.alert.2 = "alert.noMic.body"
            self.alert.0.toggle()
            return
        }
        
        // Check speech recognition permission
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            self.alert.1 = "alert.noSpeech.title"
            self.alert.2 = "alert.noSpeech.body"
            self.alert.0.toggle()
            return
        }
        
        // Generate haptic feedback
        impactFeedback(style: .light)
        
        // Change status
        withAnimation {
            self.status = .recording
        }
        
        // Start recording
        self.speechRecognizer.record(to: $transcription, previousMessage: record.text)
    }
    
    private func pauseRecording() {
        // Generate haptic feedback
        impactFeedback(style: .rigid)
        
        // Change status
        withAnimation {
            self.status = .paused
        }
        
        // Pause recording
        self.speechRecognizer.stopRecording()
        record.text = record.text + ".\n"
    }
    
    private func stopRecording() {
        // Generate haptic feedback
        impactFeedback(style: .heavy)
        
        // Change status
        withAnimation {
            self.status = .stopped
        }
        
        // Stop recording
        self.speechRecognizer.stopRecording()
    }

}

struct NewRegistrationSheet_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(data: AppData(), record: .constant(Transcription(title: "", text: "")))
    }
}
