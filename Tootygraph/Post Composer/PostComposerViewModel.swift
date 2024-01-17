//
//  PhotoComposerViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 27/02/2023.
//

import SwiftUI
import TootSDK



class PostComposerViewModel: ObservableObject{

    
    let tootClient: TootClient?
    let replyContext: PostManager?
    
    init(tootClient: TootClient?,replyContext: PostManager? = nil){
        self.replyContext = replyContext
        self.tootClient = tootClient
    }
    
    func postMedia(){
        // now do something
    }
}

