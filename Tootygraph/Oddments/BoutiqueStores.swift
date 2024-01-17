//
//  BoutiqueStores.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import Foundation
import Boutique
import TootSDK


extension Store where Item == ServerAccount {
  static let serverAccountsStore = Store<ServerAccount>(
      storage: SQLiteStorageEngine.default(appendingPath: "ServerAccounts")
  )
}
