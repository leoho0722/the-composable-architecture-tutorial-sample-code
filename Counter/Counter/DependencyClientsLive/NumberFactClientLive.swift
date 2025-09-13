//
//  NumberFactClientLive.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

extension NumberFactClient: DependencyKey {
    
    static var liveValue = Self(
        fetch: { number in
            let url = URL(string: "http://numbersapi.com/\(number)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let fact = String(decoding: data, as: UTF8.self)
            
            return fact
        }
    )
}
