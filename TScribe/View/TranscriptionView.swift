//
//  RegistrationView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI

struct TranscriptionView: View {
    
    // MARK: - View properties
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var data: AppData
    @Binding var record: Transcription
    
    @State private var isEditing: Bool = false
    @State private var alert: (Bool, String) = (false, "")
    @State private var showOptions: Bool = false
    @State private var resumeRecording: Bool = false
    
    // MARK: - View body
    
    var body: some View {
        
        Form {
            Section(header: Text("newRegistration.input.info")) {
                Text(record.title)
                    .fontWeight(.semibold)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("newRegistration.input.title"))
                    .accessibilityValue(Text(record.title))
                
                Text(record.date, style: .date)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("newRegistration.input.date"))
                    .accessibilityValue(Text(record.date, style: .date))
                
            }
            
            
            Section(header: Text("newRegistration.transcription"),
                    footer: Text("registration.tapToEdit")) {
                
                TextEditor(text: $record.text).multilineTextAlignment(.leading)
                    .frame(height: 300)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("newRegistration.transcription"))
                    .accessibilityValue(Text(record.text))
            }
        }
        
        .toolbar {
            
            ToolbarItemGroup(placement: .bottomBar) {
                
                Button(action: self.pastContentInClipboard, label: {
                    Image(systemName: "doc.on.clipboard")
                }).accessibilityHint(Text("accessibility.copy"))
                
                Spacer()

                Menu {
                    
                    Button(action: {
                        self.isEditing.toggle()
                    }, label: {
                        Label("edit.edit", systemImage: "square.and.pencil")
                    }).foregroundColor(.primary)
                    .accessibilityLabel(Text("edit.edit"))
                    
                    Button(action: {
                        self.record.inEvidence.toggle()
                        self.data.save()
                    }, label: {
                        Label(record.inEvidence == true ? "registration.unpin" : "registration.pin",
                              systemImage: record.inEvidence == true ? "pin.slash.fill" : "pin.fill")
                    })
                    .accessibilityLabel(Text(record.inEvidence == true ? "registration.unpin" : "registration.pin"))
                    
                    Button(action: {
                        self.resumeRecording.toggle()
                    }, label: {
                        Label("registration.resumeRecording", systemImage: "mic.fill")
                    })
                    
                    Button(role: .destructive, action: {
                        self.showOptions.toggle()
                    }, label: {
                        Label("registration.delete", systemImage: "trash.fill")
                    })
                    .accessibilityLabel(Text("registration.delete"))

                } label: {
                    Image(systemName: "ellipsis.circle").renderingMode(.original).font(.title3).foregroundColor(.accentColor)
                }
                .accessibilityLabel(Text("accessibility.transcription.options"))
                            
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: self.shareTranscription, label: {
                    Image(systemName: "square.and.arrow.up")
                }).accessibilityHint(Text("accessibility.share"))
            }
        }
        
        .fullScreenCover(isPresented: $resumeRecording, content: {
            RecordingView(data: self.data, record: $record)
        })
        
        .fullScreenCover(isPresented: $isEditing) {
            NavigationView {
                EditView(record: self.$record)
                    .navigationTitle("edit.title")
                
                    .navigationBarItems(leading: HStack {
                        Button(action: {
                            self.isEditing = false
                        }, label: {
                            Text("newRegistration.cancel").fontWeight(.semibold).foregroundColor(.red)
                        })
                    })
                
                    .navigationBarItems(trailing: HStack {
                        Button(action: self.saveChanges, label: {
                            Text("newRegistration.save").fontWeight(.semibold)
                        })
                    })
            }
        }
        
        .alert("alert.copied", isPresented: $alert.0) {
            Button("alert.close", role: .cancel) { }
        }
        
    }
    
    private func shareTranscription() {
        let activityVC = UIActivityViewController(activityItems: [record.text], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func pastContentInClipboard() {
        // Copy transcription to clipboard
        UIPasteboard.general.string = self.record.text
        
        // Generate haptic feedback
        impactFeedback(style: .soft)
        
        // Show alert
        self.alert = (true, "alert.copied")
    }
    
    private func saveChanges() {
        // Save
        self.data.save()
        
        // Generate haptic feedback
        notificationFeedback(type: .success)
        
        // Dismiss sheet
        self.isEditing = false
    }
}

struct InfoRow: View {
    
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
    }
}



struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TranscriptionView(data: AppData(), record: .constant(Transcription.mocks[0]))
                .navigationTitle(Transcription.mocks[0].title)
        }
    }
}
