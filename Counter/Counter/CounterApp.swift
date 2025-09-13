//
//  CounterApp.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/12.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
        #if DEBUG
            ._printChanges()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: CounterApp.store)
        }
    }
}
