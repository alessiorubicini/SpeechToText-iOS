//
//  RegistrationsListView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI

struct TranscriptionsList: View {
    
    // MARK: - View properties
    
    @ObservedObject var data: AppData
    
    @State private var showNewTranscriptionView = false
    @State private var showSettings = false
    @State private var transcription = Transcription(title: "", text: "")
    
    @Environment(\.editMode) private var editMode
    
    // MARK: - View body
    
    @ViewBuilder
    var body: some View {
        
        NavigationView {
            
            List {
                if data.transcriptions.filter({$0.inEvidence == true}).count != 0 {
                    
                    Section(header: Text("registrationList.inEvidence")) {
                        ForEach($data.transcriptions.filter({$0.inEvidence.wrappedValue == true})) { $rec in
                            
                            NavigationLink(destination: TranscriptionView(data: data, record: $rec).navigationTitle(rec.title)) {
                                TranscriptionRow(record: rec)
                            }
                            
                            .swipeActions(edge: .leading)  {
                                Button {
                                    withAnimation {
                                        rec.inEvidence.toggle()
                                    }
                                } label: {
                                    Image(systemName: rec.inEvidence ? "pin.slash.fill" : "pin.fill")
                                }
                                .tint(.orange)
                            }
                            
                            .swipeActions(edge: .trailing)  {
                                Button(action: { self.removeTranscript(with: rec.id) }, label: {
                                    Image(systemName: "trash.fill")
                                }).tint(.red)
                            }
                            
                        }
                        .onMove(perform: move)
                    }
                    .accessibilityLabel(Text("registrationList.inEvidence"))
                    
                }
                
                if data.transcriptions.filter({$0.inEvidence == false}).count != 0 {
                    
                    Section(header: Text("registrationList.all")) {
                        ForEach($data.transcriptions.filter({$0.inEvidence.wrappedValue == false})) { $rec in
                            
                            NavigationLink(destination: TranscriptionView(data: data, record: $rec).navigationTitle(rec.title)) {
                                TranscriptionRow(record: rec)
                            }
                            
                            .swipeActions(edge: .leading)  {
                                Button {
                                    withAnimation {
                                        rec.inEvidence.toggle()
                                    }
                                } label: {
                                    Image(systemName: rec.inEvidence ? "pin.slash.fill" : "pin.fill")
                                }
                                .tint(.orange)
                            }
                            
                            .swipeActions(edge: .trailing) {
                                Button(action: { self.removeTranscript(with: rec.id) }, label: {
                                    Label("registrationList.delete", systemImage: "trash.fill")
                                }).tint(.red)
                            }
                            
                        }
                        .onMove(perform: move)
                    }
                    .accessibilityLabel(Text("registrationList.all"))
                    
                }
            }
            
            .toolbar {
                
                // Bottom bar
                ToolbarItemGroup(placement: .bottomBar) {
                    
                    Button(action: {
                        self.showSettings.toggle()
                    }, label: {
                        Image(systemName: "gearshape.fill").font(.title3)
                    })
                    
                    Spacer()
                    
                    Text(String(format: NSLocalizedString("registrationList.counter", comment: ""), data.transcriptions.count)).font(.footnote)
                        .accessibilityLabel(Text(String(format: NSLocalizedString("registrationList.counter", comment: ""), data.transcriptions.count)))
                    
                    Spacer()
                    
                    Button(action: {
                        self.showNewTranscriptionView.toggle()
                    }, label: {
                        Image(systemName: "mic.fill.badge.plus").font(.title3)
                    })
                    .accessibilityLabel(Text("newRegistration.title"))
                    
                }
                
                // Edit button
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            
            .fullScreenCover(isPresented: $showNewTranscriptionView) {
                RecordingView(data: self.data, record: $transcription)
                    .onDisappear {
                        self.transcription = Transcription(title: "", text: "")
                    }
            }
            
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            
            .navigationBarTitle("registrationList.title")
            
        }
    }
    
    // MARK: - Private methods
    
    private func move(from source: IndexSet, to destination: Int) {
        data.transcriptions.move(fromOffsets: source, toOffset: destination)
    }
    
    private func removeTranscript(with id: UUID) {
        // Remove transcriptions
        withAnimation {
            self.data.transcriptions.removeAll(where: {$0.id == id})
        }
        
        // Save data
        self.data.save()
    }
    
}

struct RegistrationsListView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionsList(data: AppData(debugData: Transcription.mocks))
            //.previewInterfaceOrientation(.landscapeLeft)
    }
}
