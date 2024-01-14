//
//  ActionsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 23/02/2023.
//

import SwiftUI
import TootSDK


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
          .foregroundColor(highlighted ? .accentColor.opacity(1) : .primary.opacity(0.5))
          
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
      return "square.and.arrow.up.circle"
    case .favourite:
      return "heart.circle"
    case .reply:
      return "arrowshape.turn.up.left.circle"
    case .boost:
      return "tornado.circle"
    }
  }
}


