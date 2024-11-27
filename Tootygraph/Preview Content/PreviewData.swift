//
//  PreviewData.swift
//  Tootygraph
//
//  Created by Sam on 26/11/2024.
//

import SwiftData
import SwiftUI

/**
 Preview sample data.
 */
struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: FediAccount.self,
            configurations: config
        )
        SampleData.createSampleData(into: container.mainContext)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
          content.modelContainer(context)
    }
    
    static func createSampleData(into modelContext: ModelContext) {
        Task { @MainActor in
            let sampleAccounts: [FediAccount] = FediAccount.Samples.all
            
            let sampleData: [any PersistentModel] = sampleAccounts
            sampleData.forEach {
                modelContext.insert($0)
            }
            
            try? modelContext.save()
        }
    }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
