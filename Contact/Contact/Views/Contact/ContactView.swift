//
//  ContactView.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import SwiftUI

struct ContactView: View {
    
    @Bindable var store: StoreOf<ContactFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    makeContactCells(contact: contact)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    addContactButton
                }
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.addContact, action: \.destination.addContact
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert(
            $store.scope(
                state: \.destination?.alert, action: \.destination.alert
            )
        )
    }
}

private extension ContactView {
    
    /// 新增聯絡人按鈕 (位於 navigationBar Trailing)
    @ViewBuilder
    var addContactButton: some View {
        Button {
            store.send(.addContactButtonTapped)
        } label: {
            Image(systemName: "plus")
        }
    }
    
    /// 根據 Contact 聯絡人資料建立出 Cell
    ///
    /// - Parameters:
    ///   - contact: 聯絡人資料
    @ViewBuilder
    func makeContactCells(contact: Contact) -> some View {
        HStack {
            Text(contact.name)
            Spacer()
            Button {
                store.send(.deleteContactButtonTapped(id: contact.id))
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
            }
        }
    }
}

#Preview {
    ContactView(
        store: Store(initialState: ContactFeature.State(
            contacts: [
                Contact(id: UUID(), name: "Leo Ho")
            ]
        )) {
            ContactFeature()
        }
    )
}
