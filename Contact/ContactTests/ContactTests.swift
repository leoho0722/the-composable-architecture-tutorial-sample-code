//
//  ContactTests.swift
//  ContactTests
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import Contact

struct ContactTests {

    @Test
    func test_addContact() async throws {
        // Given
        
        // 1. 透過 `TestStore` 建立出 Store
        let store = await TestStore(initialState: ContactFeature.State()) {
            ContactFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        // 2. 透過 Store 發送 `.addContactButtonTapped` 事件
        await store.send(.addContactButtonTapped) {
            // 2-1. 設定初始狀態
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "")
                )
            )
        }
        
        // When
        
        // 3. 透過 Store 發送 `設定聯絡人名字` 事件
        await store.send(\.destination.addContact.setName, "Leo Ho") {
            // 3-1. 將聯絡人名字進行修改
            $0.destination?.modify(\.addContact) {
                $0.contact.name = "Leo Ho"
            }
        }
        
        // 4. 透過 Store 發送 `.saveButtonTapped` 事件
        await store.send(\.destination.addContact.saveButtonTapped)
        
        // 5. 當觸發 `.saveButtonTapped` 事件時，由 `AddContactFeature` 發送 Action
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Leo Ho")
        ) {
            // Then
            
            // 6. 驗證 contacts 陣列中的資料
            $0.contacts = [
                Contact(id: UUID(0), name: "Leo Ho")
            ]
        }
        
        // 7. 透過 Store 發送 `.dismiss` 事件
        await store.receive(\.destination.dismiss) {
            // 7-1. 清除 destination
            $0.destination = nil
        }
    }
}
