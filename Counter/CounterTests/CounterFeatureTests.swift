//
//  CounterFeatureTests.swift
//  CounterTests
//
//  Created by Leo Ho on 2025/9/12.
//

import ComposableArchitecture
import Testing

@testable import Counter

@MainActor
struct CounterFeatureTests {

    @Test
    func testIncrementAndDecrementAction() async throws {
        // 1. 使用 `TestStore` 建立 Store
        // 1-1. State 需遵循 `Equatable` Protocol，才能在測試中進行比對
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        // 2. 發送 Action
        // 2-1. 使用 Store 發送 `.incrementButtonTapped` Action
        await store.send(.incrementButtonTapped) {
            // 2-1-1. 聲明狀態變化後的結果
            $0.count = 1
        }
        
        // 2-2. 使用 Store 發送 `.decrementButtonTapped` Action
        await store.send(.decrementButtonTapped) {
            // 2-2-1. 聲明狀態變化後的結果
            $0.count = 0
        }
    }

    @Test
    func testTimerRunning() async throws {
        // 1. 使用 `TestClock` 建立用於測試的 Clock
        let clock = TestClock()
        
        // 2. 使用 `TestStore` 建立 Store
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // 3. 發送 Action
        // 3-1. 使用 Store 發送 `.toggleTimerButtonTapped` Action
        await store.send(.toggleTimerButtonTapped) {
            // 3-1-1. 聲明狀態變化後的結果
            $0.isTimerRunning = true
        }
        
        // 3-2. 控制 clock 增加 1 秒
        await clock.advance(by: .seconds(1))
        
        // 3-3. 聲明期望收到 `.timerTick` Effect
        await store.receive(\.timerTick) {
            // 3-3-1. 並期望 `count` 狀態更改為 1
            $0.count = 1
        }
        
        // 3-4. 使用 Store 再次發送 `.toggleTimerButtonTapped` Action
        await store.send(.toggleTimerButtonTapped) {
            // 3-4-1. 聲明狀態變化後的結果
            $0.isTimerRunning = false
        }
    }
    
    @Test
    func testNumberFactWithNetworkRequest() async throws {
        // 1. 使用 `TestStore` 建立 Store
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFactClient.fetch = {
                "\($0) is a good number"
            }
        }
        
        // 2. 發送 Action
        // 2-1. 使用 Store 發送 `.factButtonTapped` Action
        await store.send(.factButtonTapped) {
            // 2-1-1. 將 `isLoading` 狀態更改為 true
            $0.isLoading = true
        }
        
        // 2-2. 聲明期望收到 `.factResponse` Effect
        await store.receive(\.factResponse, timeout: .seconds(2)) {
            // 2-2-1. 聲明狀態變化後的結果
            $0.isLoading = false
            $0.fact = "0 is a good number"
        }
    }
}
