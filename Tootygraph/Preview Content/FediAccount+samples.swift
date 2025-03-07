//
//  FediAccount+samples.swift
//  Tootygraph
//
//  Created by Sam on 26/11/2024.
//
import Foundation
import TootSDK

extension FediAccount {

    enum Samples {

        nonisolated(unsafe) static let sam = FediAccount(TestAccounts.sam)
        nonisolated(unsafe) static let alpaca = FediAccount(TestAccounts.alpaca)
        nonisolated(unsafe) static let all: [FediAccount] = [
            sam, alpaca
        ]
        
    }
}
