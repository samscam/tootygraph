//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import Foundation
import Combine
import Boutique

enum SettingsKeys: String{
  case jaunty
  case descriptions
}

class Settings: ObservableObject {
  @StoredValue(key:SettingsKeys.jaunty.rawValue) var jaunty: Bool = false
  @StoredValue(key:SettingsKeys.descriptions.rawValue) var descriptions: Bool = true
  
}
 
