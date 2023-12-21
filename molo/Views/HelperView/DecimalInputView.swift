
import SwiftUI
import Combine

struct DecimalInputView: View {
    var prompt: String

    @State private var decimalValue = ""

    @Binding var value: Double?

    init(prompt: String, value: Binding<Double?>) {
        self.prompt = prompt
        self._value = value
        self._decimalValue = State(initialValue: value.wrappedValue?.description ?? "")
    }

    var body: some View {
        TextField(prompt, text: $decimalValue)
        .onReceive(Just(decimalValue)) { newValue in
            let filtered = newValue.filter { "0123456789.".contains($0) }
            if filtered != newValue {
                self.decimalValue = filtered
            }
            
            value = Double(filtered)
        }
    }
}

struct DecimalInputView_Previews: PreviewProvider {
    @State static var value: Double? = 0.0

    static var previews: some View {
        DecimalInputView(prompt: "成本", value: $value)
    }
}
