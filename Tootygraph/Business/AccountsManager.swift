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

class AccountsManager: ObservableObject {
  // Nope we can't be having this... credentials need to be in the keychain
  @Stored(in: .serverAccountsStore) var accounts: [ServerAccount]
  
  @Published var selectedClient: TootClient? = nil
  
  func addServerAccount(serverAccount: ServerAccount) async throws{
    try await $accounts.insert(serverAccount)
  }
  
  func connect(_ serverAccount: ServerAccount) async throws {
    let client = try await TootClient(connect: serverAccount.instanceURL, accessToken: serverAccount.accessToken)
    DispatchQueue.main.async {
      self.selectedClient = client
    }
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
    
    let serverAccount = ServerAccount(username: client.clientName, instanceURL: url, accessToken: accessToken)
    try await addServerAccount(serverAccount: serverAccount)
    
    DispatchQueue.main.async {
      self.selectedClient = client
    }
  }
}

struct ServerAccount: Codable, Equatable, Identifiable, Hashable {
  
  let username: String
  let instanceURL: URL
  let accessToken: String?
  
  var id: String {
    username
  }
}
