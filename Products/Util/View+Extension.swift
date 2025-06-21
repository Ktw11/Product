//
//  View+Extension.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideScrollIndicator() -> some View {
        if #available(iOS 16, *) {
            self.modifier(HideScrollIndicator())
        } else {
            self.modifier(LegacyHideScrollIndicator())
        }
    }
}
