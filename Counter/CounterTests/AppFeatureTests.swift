//
//  AppFeatureTests.swift
//  CounterTests
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Testing

@testable import Counter

@MainActor
struct AppFeatureTests {

    @Test
    func incrementInFirstTab() async throws {
        // 1. 使用 `TestStore` 建立 Store
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // 2. 發送 Action
        // 2-1. 使用 Store 向 Tab1 發送 `.incrementButtonTapped` Action
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }

}
