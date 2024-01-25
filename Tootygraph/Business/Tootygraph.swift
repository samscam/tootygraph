//
//  Tootygraph.swift
//  Tootygraph
//
//  Created by Sam on 22/01/2024.
//

import Foundation

// Top level state and injection of everything

@MainActor
class Tootygraph: ObservableObject {
    let accountsManager: AccountsManager = AccountsManager()
    
    @Injected(\.settingsManager) var settingsManager: SettingsManager

}
