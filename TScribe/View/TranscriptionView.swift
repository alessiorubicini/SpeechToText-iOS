//
//  RegistrationView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI
import AlertToast

struct TranscriptionView: View {
    
    // MARK: - View properties
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var record: Transcription
    let saveAction: () -> Void
    
    @State private var isEditing = false
    @State private var alert = (false, "")
    
    @State private var showOptions = false
    
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
            
            
            Section(header: Text("newRegistration.transcription")) {
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

                        self.saveAction()

                    }, label: {
                        Label(record.inEvidence == true ? "registration.unpin" : "registration.pin", systemImage: record.inEvidence == true ? "pin.slash.fill" : "pin.fill")
                    }).foregroundColor(.orange)
                        .accessibilityLabel(Text(record.inEvidence == true ? "registration.unpin" : "registration.pin"))
                    
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
        }
        
        .navigationBarItems(trailing: HStack {
            Button(action: self.shareTranscription, label: {
                Image(systemName: "square.and.arrow.up")
            }).accessibilityHint(Text("accessibility.share"))
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
        
        .toast(isPresenting: $alert.0){
            AlertToast(displayMode: .alert, type: .complete(.orange), title: NSLocalizedString(alert.1, comment: ""))
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
        self.saveAction()
        
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
            TranscriptionView(record: .constant(Transcription.mocks[0]), saveAction: {})
                .navigationTitle(Transcription.mocks[0].title)
        }
    }
}
