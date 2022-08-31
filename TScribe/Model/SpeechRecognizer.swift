//
//  SpeechRecognizer.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//
import AVFoundation
import Foundation
import Speech
import SwiftUI

/// A helper for transcribing speech to text using AVAudioEngine.
struct SpeechRecognizer {
    
    private class SpeechAssist {
        var audioEngine: AVAudioEngine?
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let speechRecognizer = SFSpeechRecognizer()

        deinit {
            reset()
        }

        func reset() {
            recognitionTask?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            recognitionRequest = nil
            recognitionTask = nil
        }
    }

    private let assistant = SpeechAssist()
    var transcribedAudio: String = ""

    /**
        Begin transcribing audio.
     
        Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopRecording()`.
        The resulting transcription is continuously written to the provided text binding.
     
        -  Parameters:
            - speech: A binding to a string where the transcription is written.
     */
    func record(to speech: Binding<String>, previousMessage: String) {
        
        canAccess { authorized in
            guard authorized else {
                relay(speech, message: "Access denied")
                return
            }

            assistant.audioEngine = AVAudioEngine()
            guard let audioEngine = assistant.audioEngine else {
                fatalError("Unable to create audio engine")
            }
            
            assistant.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = assistant.recognitionRequest else {
                fatalError("Unable to create request")
            }
            recognitionRequest.shouldReportPartialResults = true

            do {
                
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                let inputNode = audioEngine.inputNode

                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                    recognitionRequest.append(buffer)
                }

                audioEngine.prepare()
                
                try audioEngine.start()
                
                assistant.recognitionTask = assistant.speechRecognizer?.recognitionTask(with: recognitionRequest) { (result, error) in
                    var isFinal = false
                    
                    if let result = result {
                        relay(speech, message: previousMessage + result.bestTranscription.formattedString)
                        isFinal = result.isFinal
                    }

                    if error != nil || isFinal {
                        audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        self.assistant.recognitionRequest = nil
                    }
                }
            } catch {
                print("Error transcibing audio: " + error.localizedDescription)
                assistant.reset()
            }
        }
    }
    
    private func relay(_ binding: Binding<String>, message: String) {
        DispatchQueue.main.async {
            binding.wrappedValue = message
        }
    }
    
    /// Pause transcribing audio.
    func pauseRecording() {
        assistant.audioEngine?.pause()
    }
    
    /// Stop transcribing audio.
    func stopRecording() {
        assistant.reset()
    }
    
    private func canAccess(withHandler handler: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { authorized in
                    handler(authorized)
                }
            } else {
                handler(false)
            }
        }
    }
    
}
