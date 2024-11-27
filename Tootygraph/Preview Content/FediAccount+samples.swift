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
        static let all: [FediAccount] = [
            sam, alpaca
        ]
        static let sam = FediAccount(TestAccounts.sam)
        static let alpaca = FediAccount(TestAccounts.alpaca)
        
    }
}
