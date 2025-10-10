//
//  AddContactFeature.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AddContactFeature {
    
    @ObservableState
    struct State: Equatable {
        
        /// 當前新增的聯絡人資料
        var contact: Contact
    }
    
    enum Action {
        
        /// 點擊 取消按鈕 時
        case cancelButtonTapped
        
        /// 點擊 儲存按鈕 時
        case saveButtonTapped
        
        /// 設定 委任事件
        case delegate(Delegate)
        
        /// 設定 聯絡人名稱 時
        case setName(String)
        
        @CasePathable
        enum Delegate: Equatable {
            
            /// 儲存欲新增的聯絡人
            ///
            /// - Parameters:
            ///   - contract: 要新增的聯絡人
            case saveContact(Contact)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    @Dependency(\.dismiss) var dismiss
                    
                    await dismiss()
                }
                
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    @Dependency(\.dismiss) var dismiss
                    
                    await send(.delegate(.saveContact(contact)))
                    await dismiss()
                }
                
            case .delegate:
                return .none
                
            case let .setName(name):
                state.contact.name = name
                
                return .none
            }
        }
    }
}
