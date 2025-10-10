//
//  AppView.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        ContactView(
            store: store.scope(state: \.contact, action: \.contact)
        )
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
