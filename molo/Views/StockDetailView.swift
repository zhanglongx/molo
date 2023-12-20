
import SwiftUI

struct StockDetailView: View {
    @Environment(StockModel.self) var model: StockModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var stock: Stock

    var body: some View {
        NavigationStack {
            StockFormView(stock: $stock)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("编辑")
                    .font(.title)
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
                        model.update(stock)
                    } label: {
                        Text("完成")
                    }
                }
            }
            #if os(macOS)
            .padding()
            #endif
        }
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
