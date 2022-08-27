//
//  SettingsView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 22/06/21.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - View properties
    
    @AppStorage("hapticFeedback") private var haptic = true
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - View body
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("settings.preferences")) {
                    Toggle("settings.haptic", isOn: $haptic)
                }
                
                Section(header: Text("settings.info")) {
                    HStack {
                        Text("settings.version")
                        Spacer()
                        Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                    }
                    
                    NavigationLink(destination: PrivacyTermsView().navigationTitle("Privacy policy")) {
                        Label("settings.privacy.title", systemImage: "hand.raised.slash.fill")
                    }
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        Label("settings.permissions", systemImage: "lock.shield.fill")
                    })
                    
                    Link(destination: URL(string: "http://alessiorubicini.altervista.org")!, label: {
                        Label("settings.contact", systemImage: "link")
                    }).accessibilityLabel(Text("settings.contact"))
                }
                
            }.navigationTitle("settings.title")
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(role: .cancel, action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("settings.close")
                        })
                    }
                }
        }
        
    }
}

struct PrivacyTermsView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Privacy Policy").font(.title2).padding(.vertical, 10)
            Text("settings.privacy")
            
            Text("Terms of use").font(.title2).padding(.top, 30).padding(.vertical, 10)
            Text("settings.terms")
            
            Spacer()
        }.padding()
        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView().navigationTitle("Settings")
        }
    }
}
