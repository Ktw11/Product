//
//  HideScrollIndicator.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

@available(iOS 16, *)
struct HideScrollIndicator: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
    }
}

struct LegacyHideScrollIndicator: ViewModifier {
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}
