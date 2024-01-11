//
//  AddServerView.swift
//  Tootygraph
//
//  Created by Sam on 10/01/2024.
//

import Foundation
import SwiftUI

struct AddServerView: View {
    
    @EnvironmentObject var accountsManager: AccountsManager
    
    @State var newAccountURLString: String = ""
    @State var connecting: Bool = false
    @State var errorMessage: String?
    
    var fieldFocussed: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment:.leading){
            
            Group{
                Text("Add a server").font(.title)
                Text("Tootygraph supports Mastodon, Pixelfed, and possibly others").font(.caption)
            }.multilineTextAlignment(.leading)
            
            HStack{
                TextField("instance url", text: $newAccountURLString)
                    .font(.title2)
                    .autocorrectionDisabled(true)
                    .keyboardType(.URL)
                    .submitLabel(.go)
                    .textContentType(.URL)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.leading)
                    .focused(fieldFocussed)
                    .padding(10)
                    .background(.bar)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .onSubmit {
                        tryToConnect()
                    }
                    .onChange(of: newAccountURLString) { oldValue, newValue in
                        withAnimation{
                            connectionTask?.cancel()
                            errorMessage = nil
                        }
                    }
                    .frame(maxHeight:.infinity)
                
                Button {
                    tryToConnect()
                } label: {
                    HStack{
                        
                        if connecting {
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .padding(.horizontal,3)
                                .foregroundColor(.white)
                                .frame(maxHeight:.infinity)
                        } else {
                            Text("go").frame(maxHeight:.infinity)
                        }
                    }
                    
                }
                .disabled(connecting)
                .buttonStyle(.borderedProminent)
                    
                    
            }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxHeight:150)
            
            if let errorMessage {
                HStack(alignment: .firstTextBaseline){
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(errorMessage)
                        .frame(maxWidth:.infinity)
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(.black)
                .padding(5)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                
            }
        }
    }
    @State var connectionTask: Task<(),Never>?
    
    func tryToConnect() {
        connectionTask = Task{
            withAnimation{
                errorMessage = nil
                connecting = true
                fieldFocussed.wrappedValue = false
            }
            do {
                
                try await accountsManager.startAuth(urlString: newAccountURLString)
                newAccountURLString = ""
            } catch {
                
                withAnimation{
                    errorMessage = error.localizedDescription
                    connecting = false
                }
            }
            withAnimation{
                connecting = false
            }
        }
    }
}

#Preview(traits:.sizeThatFitsLayout){
    @FocusState var fieldFocussed: Bool
    return AddServerView(errorMessage:"oh dear",fieldFocussed: $fieldFocussed)

}
