//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 07/02/2023.
//

import SwiftUI
import Boutique



struct SettingsMenuView: View {
  
  @EnvironmentObject var settings: SettingsManager
  
  @State private var showingPopover: Bool = false
  
  var body: some View {

      VStack(alignment:.leading){
        Text("Settings").font(.title)
        Toggle("Jaunty angles",isOn: settings.$jaunty.binding)
        
        Toggle("Descriptions first", isOn: settings.$descriptionsFirst.binding)
        Toggle("Include posts with no pictures", isOn: settings.$includeTextPosts.binding)
        Toggle("Show post content", isOn: settings.$showContent.binding)
        Spacer()
      }
  }
}

struct SettingsMenu_Previews: PreviewProvider {
  static let settings = SettingsManager()
  
  static var previews: some View{
    SettingsMenuView().environmentObject(settings)
  }
  
}
