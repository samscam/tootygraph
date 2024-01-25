//
//  SplashView.swift
//  Tootygraph
//
//  Created by Sam on 21/01/2024.
//

import Foundation
import SwiftUI

struct SplashView: View {
    
    var splashMessage: String? = nil
    
    var body: some View {
        Image("greenicon1024")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .photoFrame()
            .frame(maxWidth:200)

        if let splashMessage {
            
            Text(splashMessage)
                .multilineTextAlignment(.center)
                .bold()
                .padding(.horizontal,20)
                .padding(.top,40)
        }
        
    }
}

#Preview {
    let message: String? = "Hello something is happengng. Lorem ipsum whatnot fotnot bibbety bobbety boo."
    return SplashView(splashMessage: message)
    
}
