//
//  HapticFeedback.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import Foundation
import SwiftUI

func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    
    if UserDefaults.standard.bool(forKey: "hapticFeedback") {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
}

func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
    if UserDefaults.standard.bool(forKey: "hapticFeedback") {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

func selectionFeedback() {
    
    if UserDefaults.standard.bool(forKey: "hapticFeedback") {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
