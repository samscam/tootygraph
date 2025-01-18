//
//  Settings.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import Foundation
import SwiftUI


enum SettingsKeys: String{
    case jaunty
    case descriptionsFirst
    case includeTextPosts
    case showContent
}


@Observable
final class SettingsManager {
    
    var foo: Bool = false
    
    var jaunty: Bool {
        get {
            access(keyPath: \.jaunty)
            return UserDefaults.standard.bool(forKey: "jaunty")
        }
        set {
            withMutation(keyPath: \.jaunty) {
                UserDefaults.standard.setValue(newValue, forKey: "jaunty")
            }
        }
    }
    
    var descriptionsFirst: Bool {
        get {
            access(keyPath: \.descriptionsFirst)
            return UserDefaults.standard.bool(forKey: "descriptionsFirst")
        }
        set {
            withMutation(keyPath: \.descriptionsFirst) {
                UserDefaults.standard.setValue(newValue, forKey: "descriptionsFirst")
            }
        }
    }
    
    var includeTextPosts: Bool {
        get {
            access(keyPath: \.includeTextPosts)
            return UserDefaults.standard.bool(forKey: "includeTextPosts")
        }
        set {
            withMutation(keyPath: \.includeTextPosts) {
                UserDefaults.standard.setValue(newValue, forKey: "includeTextPosts")
            }
        }
    }
    
    var showContent: Bool {
        get {
            access(keyPath: \.showContent)
            return UserDefaults.standard.bool(forKey: "showContent")
        }
        set {
            withMutation(keyPath: \.showContent) {
                UserDefaults.standard.setValue(newValue, forKey: "showContent")
            }
        }
    }
    
    init(){
        
        // Set up behaviour for interdependent settings
        //    $showContent.publisher.sink { [weak self] newValue in
        //      if newValue == false {
        //          self?.$includeTextPosts.set(false)
        //      }
        //    }.store(in: &disposebag)
        //
        //    $includeTextPosts.publisher.sink { [weak self] newValue in
        //      if newValue == true {
        //        self?.$showContent.set(true)
        //      }
        //    }.store(in: &disposebag)
        
    }
    
}
