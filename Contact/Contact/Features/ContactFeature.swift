//
//  ContactFeature.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ContactFeature {
    
    @ObservableState
    struct State: Equatable {
        
        /// 顯示在 List 中的聯絡人清單
        var contacts: IdentifiedArrayOf<Contact> = []
        
        /// 管理 目標 狀態
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        
        /// 點擊 新增聯絡人按鈕 時
        case addContactButtonTapped
        
        /// 點擊 刪除聯絡人按鈕 時
        case deleteContactButtonTapped(id: Contact.ID)
        
        /// 管理 目標 動作
        case destination(PresentationAction<Destination.Action>)
        
        enum Alert: Equatable {
            
            /// 點擊 Alert 確認刪除 按鈕
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addContactButtonTapped:
                @Dependency(\.uuid) var uuid
                
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: uuid(), name: "")
                    )
                )
                
                return .none
                
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                
                return .none
                
            case .deleteContactButtonTapped(let id):
                state.destination = .alert(
                    AlertState {
                        // 定義顯示在 Alert 上的標題
                        TextState("警告")
                    } actions: {
                        // 定義 Alert 上的 Action 按鈕
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("刪除")
                        }
                    } message: {
                        // 定義顯示在 Alert 上的內容
                        TextState("是否要刪除聯絡人？")
                    }
                )
                
                return .none
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
    }
}

extension ContactFeature {
    
    @Reducer
    enum Destination {
        
        /// 目標：新增聯絡人
        case addContact(AddContactFeature)

        /// 目標：顯示 Alert
        case alert(AlertState<ContactFeature.Action.Alert>)
    }
}

extension ContactFeature.Destination.State: Equatable {}
