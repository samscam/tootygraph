//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 07/02/2023.
//

import SwiftUI
import Boutique



struct SettingsMenu: View {
  
  @EnvironmentObject var settings: Settings
  
  @State private var showingPopover: Bool = false
  
  var body: some View {
    Button(action: {
      showingPopover.toggle()
    }, label: {
      Image(systemName: "beach.umbrella.fill")
      
    }).buttonStyle(.plain)
    .popover(isPresented: $showingPopover, content: {
      VStack(alignment:.leading){
        Text("Settings").font(.largeTitle)
        Toggle("Jaunty angles",isOn: settings.$jaunty.binding)
        
        Toggle("Descriptions first", isOn: settings.$descriptionsFirst.binding)
        Toggle("Include posts with no pictures", isOn: settings.$includeTextPosts.binding)
        Toggle("Show post content", isOn: settings.$showContent.binding)
        Spacer()
      }
      .padding()
      
    })
  }
}

struct SettingsMenu_Previews: PreviewProvider {
  static let settings = Settings()
  
  static var previews: some View{
    SettingsMenu().environmentObject(settings)
  }
  
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
