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
protocol AccountsManagerProtocol: ObservableObject {
  var accounts: [ServerAccount] { get }
  var selectedClient: TootClient? { get }
  func addServerAccount(_ serverAccount: ServerAccount) async throws
  func removeServerAccount(_ serverAccount: ServerAccount) async throws
  func connect(_ serverAccount: ServerAccount) async throws
  func startAuth(urlString: String) async throws
  func signOut()
}

@MainActor
class MockAccountsManager: AccountsManagerProtocol {
  
  @Published var accounts: [ServerAccount] = []
  @Published var selectedClient: TootClient? = nil
  
  func addServerAccount(_ serverAccount: ServerAccount) async throws {
    
  }
  
  func removeServerAccount(_ serverAccount: ServerAccount) async throws {
    
  }
  
  func connect(_ serverAccount: ServerAccount) async throws {
    
  }
  
  func startAuth(urlString: String) async throws {
    
  }
  
  func signOut() {
    
  }

}

@MainActor
class AccountsManager: AccountsManagerProtocol {
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
    
    // We need to refresh the server account with the user account
    var serverAccount = serverAccount
    let userAccount = try await client.verifyCredentials()
    serverAccount.userAccount = userAccount
    try await addServerAccount(serverAccount)
    
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
    
    let serverAccount = ServerAccount(id: userAccount.id, username: userAccount.acct, instanceURL: url, accessToken: accessToken, userAccount: userAccount)
    try await addServerAccount(serverAccount)
    
    
    self.selectedClient = client
    
  }
  func signOut(){
    selectedClient = nil
  }
  

}

