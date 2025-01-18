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
    
    var accountsManager: AccountsManager
    var settingsManager: SettingsManager
    var modelContainer: ModelContainer
    
    init(){
        print("New tootygraph")
        do {
            modelContainer = try ModelContainer(for: FediAccount.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        settingsManager = SettingsManager()
        accountsManager = AccountsManager(modelContainer: modelContainer)
    }
    
    
    var context: ModelContext {
        return modelContainer.mainContext
    }
}
