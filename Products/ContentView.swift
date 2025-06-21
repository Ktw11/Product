//
//  ContentView.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    
    @Environment(\.dependencyContainer) private var dependencyContainer
    
    var body: some View {
        NavigationView {
            dependencyContainer.buildProductListView()
                .padding(.horizontal, 24)
                .navigationTitle("상품 목록")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    ContentView()
}
