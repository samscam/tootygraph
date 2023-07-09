//
//  AccountsViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import Foundation
import TootSDK
import Boutique

enum AccountCreationError: Error {
  case invalidURL
}

@MainActor
class AccountsManager: ObservableObject {
  // Nope we can't be having this... credentials need to be in the keychain
  @Stored(in: .serverAccountsStore) var accounts: [ServerAccount]
  
  @Published var selectedClient: TootClient? = nil
  
  func addServerAccount(_ serverAccount: ServerAccount) async throws{
    try await $accounts.insert(serverAccount)
  }
  
  func removeServerAccount(_ serverAccount: ServerAccount) async throws{
    try await $accounts.remove(serverAccount)
  }
  
  func connect(_ serverAccount: ServerAccount) async throws {
    let client = try await TootClient(connect: serverAccount.instanceURL, accessToken: serverAccount.accessToken)
    
    self.selectedClient = client
    
  }
  
  func startAuth(urlString: String) async throws {
    var urlString = urlString
    
    // make sure we have a scheme on the url
    if !urlString.starts(with: "https://") {
      urlString = "https://"+urlString
    }
    
    guard let url = URL(string: urlString) else {
      throw AccountCreationError.invalidURL
    }
    
    let client = try await TootClient(connect: url)
    
    let accessToken = try await client.presentSignIn(callbackURI: "tootygraph://auth")
    let userAccount = try await client.verifyCredentials()
    
    let serverAccount = ServerAccount(id: userAccount.id, username: userAccount.acct, instanceURL: url, accessToken: accessToken)
    try await addServerAccount(serverAccount)
    
    
    self.selectedClient = client
    
  }
  func signOut(){
    selectedClient = nil
  }
  

}

struct ServerAccount: Codable, Equatable, Identifiable, Hashable {
  
  let id: String
  let username: String
  let instanceURL: URL
  let accessToken: String?
  
}
