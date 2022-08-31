//
//  RegistrationCard.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import SwiftUI

struct TranscriptionRow: View {
    
    let record: Transcription
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(record.title).fontWeight(.semibold)
                Text(record.date, style: .date).foregroundColor(.secondary)
                    //.padding(.top, 1)
            }
            
            Spacer()
            
        }.padding(.horizontal, 5)
    }
}

struct RegistrationCard_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionRow(record: Transcription.mocks[0])
            .previewLayout(.sizeThatFits)
    }
}
