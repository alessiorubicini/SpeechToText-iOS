//
//  RecordingStatus.swift
//  TScribe
//
//  Created by Alessio Rubicini on 14/06/21.
//

import Foundation
import SwiftUI

enum RecordingStatus: String {
    case recording = "newRegistration.status.recording"
    case paused = "newRegistration.status.paused"
    case stopped = "newRegistration.status.stopped"
    
    var color: Color {
        switch self {
        case .recording: return .green
        case .paused: return .orange
        case .stopped: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .recording: return "music.mic"
        case .paused: return "pause.fill"
        case .stopped: return "stop.fill"
        }
    }
}
