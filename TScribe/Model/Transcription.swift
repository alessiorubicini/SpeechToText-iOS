//
//  Registration.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import Foundation
import SwiftUI

struct Transcription: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var date: Date
    var text: String
    var inEvidence: Bool
    
    init(id: UUID = UUID(), title: String, text: String) {
        self.id = id
        self.title = title
        self.date = Date()
        self.text = text
        self.inEvidence = false
    }
    
    
}

extension Transcription {
    
    static let mocks = [
        Transcription(title: "Lezione italiano", text: "Ciao ragazzi"),
        Transcription(title: "Discussione cittadinanza", text: "Ciao ragazzi")
    ]
    
}
