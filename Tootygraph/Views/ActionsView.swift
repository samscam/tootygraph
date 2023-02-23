//
//  ActionsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 23/02/2023.
//

import SwiftUI
import TootSDK

struct ActionsView: View {
  let actions: [Action]
  
  var body: some View {
    Grid{
      GridRow{
        ForEach(actions) { action in
          Button {
            // action
          } label: {
              Image(systemName: action.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                
          }.buttonStyle(PlainButtonStyle())
          
        }
      }.frame(maxHeight: 40)
    }
  }
}

struct ActionWrap {
  
  let post: PostWrapper
  let client: TootClient
  
  
  
}

enum Action: String, Identifiable, CaseIterable {
  case reply
  case boost
  case favourite
  case share
  
  var id: String {
    return self.rawValue
  }
  
  var iconName: String {
    switch self {
    case .share:
      return "square.and.arrow.up.circle.fill"
    case .favourite:
      return "heart.circle.fill"
    case .reply:
      return "arrowshape.turn.up.left.circle.fill"
    case .boost:
      return "tornado.circle.fill"
    }
  }
}


