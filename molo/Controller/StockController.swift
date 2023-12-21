
import SwiftUI

extension Stock {
    var costPercent: Double? {
        guard let price = price, let cost = cost else {
            return nil
        }

        return (price - cost) / cost * 100
    }
}
