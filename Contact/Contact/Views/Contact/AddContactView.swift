//
//  AddContactView.swift
//  Contact
//
//  Created by Leo Ho on 2025/9/14.
//

import ComposableArchitecture
import SwiftUI

struct AddContactView: View {
    
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.saveButtonTapped)
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: Store(initialState: AddContactFeature.State(
                contact: .init(id: UUID(), name: "Leo Ho")
            )) {
                AddContactFeature()
            }
        )
    }
}
