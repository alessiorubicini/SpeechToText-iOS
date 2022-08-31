//
//  AppData.swift
//  TScribe
//
//  Created by Alessio Rubicini on 13/06/21.
//

import Foundation

class AppData: ObservableObject {
    
    @Published var transcriptions: [Transcription] = []
    
    init(debugData: [Transcription]) {
        self.transcriptions = debugData
    }
    
    init() { }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("transcriptions.data")
    }
    
    // Save app data as JSON to local memory
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let transcriptions = self?.transcriptions else { fatalError("Self out of scope") }
            
            guard let data = try? JSONEncoder().encode(transcriptions) else { fatalError("Error encoding data") }
            
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
            
        }
    }
    
    // Load data from local memory
    func load() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            
            guard let transcriptions = try? JSONDecoder().decode([Transcription].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            
            DispatchQueue.main.async {
                self?.transcriptions = transcriptions
            }
        }
        
    }
    
}
