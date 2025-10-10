//
//  ContactApp.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import SwiftUI

@main
struct ContactApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
        #if DEBUG
            ._printChanges()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: ContactApp.store)
        }
    }
}
