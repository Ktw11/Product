//
//  EnvironmentValues+Extension.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer()
}
