//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import Foundation
import Combine
import Boutique


private struct SettingsManagerKey: InjectionKey {
    @MainActor static var currentValue: SettingsManager = SettingsManager()
}

extension InjectedValues {
    var settingsManager: SettingsManager {
        get { Self[SettingsManagerKey.self] }
        set { Self[SettingsManagerKey.self] = newValue }
    }
}


enum SettingsKeys: String{
  case jaunty
  case descriptionsFirst
  case includeTextPosts
  case showContent
}

@MainActor
class SettingsManager: ObservableObject {
  
  @StoredValue(key:SettingsKeys.jaunty.rawValue)
  var jaunty: Bool = false
  
  @StoredValue(key:SettingsKeys.descriptionsFirst.rawValue)
  var descriptionsFirst: Bool = false
  
  @StoredValue(key:SettingsKeys.includeTextPosts.rawValue)
  var includeTextPosts: Bool = false
  
  @StoredValue(key:SettingsKeys.showContent.rawValue)
  var showContent: Bool = false
  
  var disposebag = Set<AnyCancellable>()
  
  init(){
    
    // Set up behaviour for interdependent settings
    $showContent.publisher.sink { [weak self] newValue in
      if newValue == false {
          self?.$includeTextPosts.set(false)
      }
    }.store(in: &disposebag)
  
    $includeTextPosts.publisher.sink { [weak self] newValue in
      if newValue == true {
        self?.$showContent.set(true)
      }
    }.store(in: &disposebag)
    
  }
  
}
