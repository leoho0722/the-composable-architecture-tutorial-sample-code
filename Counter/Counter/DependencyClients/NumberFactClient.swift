//
//  NumberFactClient.swift
//  Counter
//
//  Created by Leo Ho on 2025/9/13.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    
    /// 定義 使用網路請求進行抓取的抽象行為
    var fetch: (Int) async throws -> String
}

extension DependencyValues {
    
    var numberFactClient: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
