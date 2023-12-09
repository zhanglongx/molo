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
        VStack {
            Text("Stocks")
                .font(.title)
                .padding()
            List {
                ForEach(model.stocks, id: \.symbol) { stock in
                    StockRowView(stock: stock)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    ContentView()
        .environment(StockModel())
}
