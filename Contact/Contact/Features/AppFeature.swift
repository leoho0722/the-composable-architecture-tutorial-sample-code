//
//  AppFeature.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State {
        
        /// 表示 聯絡人 狀態
        var contact = ContactFeature.State()
    }
    
    enum Action {
        
        /// 表示 聯絡人 動作
        case contact(ContactFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.contact, action: \.contact) {
            ContactFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .contact:
                return .none
            }
        }
    }
}
