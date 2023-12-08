//
//  ContentView.swift
//  molo
//
//  Created by zhlx on 2023/11/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(StockModel.self) var model: StockModel

    var body: some View {
        ForEach(model.stocks, id: \.symbol) { stock in
            StockRowView(stock: stock)
        }
    }
}

#Preview {
    ContentView()
        .environment(StockModel())
}
