//
//  CounterFeature.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/12.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        
        /// 當前計數
        var count: Int = 0
        
        /// 是否正在載入中
        var isLoading: Bool = false
        
        /// 透過網路請求取得的字串
        var fact: String?
        
        /// 是否 Timer 正在執行中
        var isTimerRunning: Bool = false
    }
    
    enum Action {
        
        /// 點擊 增加按鈕
        case incrementButtonTapped
        
        /// 點擊 減少按鈕
        case decrementButtonTapped
        
        /// 點擊 網路請求按鈕
        case factButtonTapped
        
        /// 收到 網路請求回傳的 Response
        case factResponse(String)
        
        /// 點擊 Timer 按鈕
        case toggleTimerButtonTapped
        
        /// Timer 觸發時要進行的操作
        case timerTick
    }
    
    enum CancelID {
        
        case timer
    }
    
    /// body 負責根據 Action 種類進行對應實作
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                
                // 沒有特別要進行處理的時候，可以回傳 `.none` Effect
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                // 需要與外部進行溝通時，可以回傳 `.run` Effect，
                // 並在 `.run` Effect closure 中與外部進行溝通。
                // 如果在 Effect closure 中需要將與外部溝通的結果傳遞給其他 Action，
                // 可以在 Effect closure 中使用 `send`，將結果傳遞給其他 Action。
                // Data Flow: View -> Action -> Store -> Reducer -> Effect -> Action -> Reducer -> State -> View
                return .run { [count = state.count] send in
                    // 將原先直接使用 `URLSession.shared.data(for:)` 進行網路請求的方法，
                    // 改為使用 `Swift Dependencies`，透過 Dependency Injection (DI) 方式注入
                    @Dependency(\.numberFactClient) var client
                    try await send(.factResponse(client.fetch(count))) // 將解碼後的 Response 發送給 `.factResponse` Action
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                
                if state.isTimerRunning {
                    return .run { send in
                        @Dependency(\.continuousClock) var clock
                        
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.timerTick) // Timer 每觸發一次，就發送一次 `.timerTick` Action
                        }
                    }
                    .cancellable(id: CancelID.timer) // 將 Effect 標記為可以取消的，並給予一個 ID
                } else {
                    return .cancel(id: CancelID.timer) // 當點擊 `Stop Timer` 時，將原本執行中的 Timer Effect 取消掉
                }
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                
                return .none
            }
        }
    }
}
