//
//  AppView.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Music")
                }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
