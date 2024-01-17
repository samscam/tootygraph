//
//  BoutiqueStores.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import Foundation
import Boutique
import TootSDK


extension Store where Item == FediAccount {
  static let serverAccountsStore = Store<FediAccount>(
      storage: SQLiteStorageEngine.default(appendingPath: "ServerAccounts")
  )
}
