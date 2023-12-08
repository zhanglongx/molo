//
//  moloApp.swift
//  molo
//
//  Created by zhlx on 2023/11/21.
//

import SwiftUI

@main
struct moloApp: App {
    @State private var model = StockModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
