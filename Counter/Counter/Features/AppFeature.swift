//
//  AppFeature.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var tab1 = CounterFeature.State()
        
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        
        case tab1(CounterFeature.Action)
        
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}
