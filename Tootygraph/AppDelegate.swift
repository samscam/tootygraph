//
//  AppDelegate.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 21/03/2023.
//

import UIKit

import Nuke
import NukeVideo

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ImageDecoderRegistry.shared.register(ImageDecoders.Video.init)
        return true
    }
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
      
      
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
