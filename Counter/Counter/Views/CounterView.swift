//
//  CounterView.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/12.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            
            HStack {
                Button {
                    // Data Flow
                    // View -> Action -> Store -> Reducer -> State -> View
                    store.send(.decrementButtonTapped)
                } label: {
                    Text("-")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button {
                    store.send(.incrementButtonTapped)
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            
            Button {
                store.send(.factButtonTapped)
            } label: {
                Text("Fact")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
            }
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button {
                store.send(.toggleTimerButtonTapped)
            } label: {
                Text(store.isTimerRunning ? "Stop Timer" : "Start Timer")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
