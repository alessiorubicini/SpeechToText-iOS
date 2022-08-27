//
//  EditView.swift
//  TScribe
//
//  Created by Alessio Rubicini on 20/06/21.
//

import SwiftUI

struct EditView: View {
    
    @Binding var record: Transcription
    
    var body: some View {
        Form {
            
            Section(header: Text("newRegistration.input.info")) {
                TextField("newRegistration.input.title", text: $record.title)
                DatePicker("newRegistration.input.date", selection: $record.date)
                    .datePickerStyle(.graphical)
            }
            
            Section {
                Toggle("newRegistration.input.inEvidence", isOn: $record.inEvidence)
            }
        }
        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(record: .constant(Transcription.mocks[0]))
            
    }
}
