//
//  ProductsApp.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

@main
struct ProductsApp: App {
    
    @Environment(\.dependencyContainer) private var dependencyContainer
    private let container: DependencyContainer = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyContainer, container)
        }
    }
}
