// This was lifted from a blog post by Pol Piella Abadia
// https://www.polpiella.dev/changing-orientation-for-a-single-screen-in-swiftui

// In turn lifted from work by Jim Dovey
// https://developer.apple.com/forums/thread/125155

// With additional thanks to Dave Burrows (been TIME Dave!)

import UIKit
import SwiftUI
import Combine

class OrientationLockedController<Content: View>: UIHostingController<OrientationLockedController.Root<Content>> {
  
  class Box{
    @Published var supportedOrientations: UIInterfaceOrientationMask = SupportedOrientationsPreferenceKey.defaultValue
  }
  
  func setSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
    setNeedsUpdateOfSupportedInterfaceOrientations()
  }
  
  private let box: Box
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return box.supportedOrientations
  }
  
  var updater: AnyCancellable?
  
  init(rootView: Content) {
    self.box = Box()
    
    let orientationRoot = Root(contentView: rootView, box: box)
    super.init(rootView: orientationRoot)

    updater = box.$supportedOrientations.sink { [weak self] newValue in
      self?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  struct Root<Content: View>: View {
    let contentView: Content
    let box: Box
    
    var body: some View {
      contentView
        .onPreferenceChange(SupportedOrientationsPreferenceKey.self) {
          box.supportedOrientations = $0
        }
    }
  }
}
