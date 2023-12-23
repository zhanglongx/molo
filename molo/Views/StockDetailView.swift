
import SwiftUI

struct StockDetailView: View {
    @Environment(StockModel.self) var model: StockModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var stockEditor: StockEditor

    var body: some View {
        NavigationStack {
            StockFormView(stockEditor: $stockEditor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("编辑")
                    .bold()
                }

                ToolbarItem(placement: cancelButtonPlacement) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("取消")
                    }
                }

                ToolbarItem(placement: saveButtonPlacement) {
                    Button {
                        toSave()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("完成")
                        .bold()
                    }
                }
            }
            #if os(macOS)
            .padding()
            #endif
        }
    }

    private func toSave() {
        let stock = stockEditor.stock

        if stockEditor.isCreate {
            model.add(by: stock.symbol, name: stock.name, cost: stock.cost)
        } else {
            model.update(by: stock.symbol, cost: stock.cost)
        }
        
        DataSource.shared.fetchData(model)
    }
    
    private var cancelButtonPlacement: ToolbarItemPlacement {
        #if os(macOS)
        .cancellationAction
        #else
        .navigationBarLeading
        #endif
    }
    
    private var saveButtonPlacement: ToolbarItemPlacement {
        #if os(macOS)
        .confirmationAction
        #else
        .navigationBarTrailing
        #endif
    }
}
