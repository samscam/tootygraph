//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 07/02/2023.
//

import SwiftUI



struct SettingsMenuView: View {
  
    @Environment(SettingsManager.self) var settings: SettingsManager
  
  @State private var showingPopover: Bool = false
  
  var body: some View {
      @Bindable var settings = settings
      VStack(alignment:.leading){
        Text("Settings").font(.title)
          Toggle("Jaunty angles",isOn: $settings.jaunty)
        
        Toggle("Descriptions first", isOn: $settings.descriptionsFirst)
        Toggle("Include posts with no pictures", isOn: $settings.includeTextPosts)
        Toggle("Show post content", isOn: $settings.showContent)
        Spacer()
      }
  }
}

struct SettingsMenu_Previews: PreviewProvider {
  static let settings = SettingsManager()
  
  static var previews: some View{
    SettingsMenuView().environment(settings)
  }
  
}
