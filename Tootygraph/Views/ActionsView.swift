//
//  ActionsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 23/02/2023.
//

import SwiftUI
import TootSDK

struct ActionsView: View {
  let actions: [ActionType]
  
  var body: some View {
    Grid{
      GridRow{
        ForEach(actions) { action in
          Rectangle()
        }
      }.frame(maxHeight: 40)
    }
  }
}

struct ActionButtonView: View{
  let highlighted: Bool
  let inProgress: Bool = false
  
  let actionType: ActionType
  
  let onTap: ()->()
  
  var body: some View {
    Button {
      onTap()
    } label: {
        Image(systemName: actionType.iconName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(highlighted ? .accentColor : .primary)
          
    }.buttonStyle(PlainButtonStyle())
  }
  
}

enum ActionType: String, Identifiable, CaseIterable {
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


