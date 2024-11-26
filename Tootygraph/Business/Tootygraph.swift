//
//  Tootygraph.swift
//  Tootygraph
//
//  Created by Sam on 22/01/2024.
//

import Foundation
import SwiftData

// Top level state and injection of everything

@MainActor

class Tootygraph {
    init(){
        print("New tootygraph")
    }
    lazy var accountsManager: AccountsManager = AccountsManager(modelContainer: modelContainer)
    
    @Injected(\.settingsManager) var settingsManager: SettingsManager
    
    nonisolated lazy var modelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: FediAccount.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
    
    var context: ModelContext {
        return modelContainer.mainContext
    }
}
