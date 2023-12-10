import Foundation
import XCTest
@testable import molo

@available(macOS 10.15, iOS 13.0, *)
class DataSourceTests: XCTestCase {
    var dataSource: DataSource!

    override func setUp() {
        super.setUp()
        dataSource = DataSource(["SH601231", "SZ000651"]) { data in
            XCTAssertEqual(data.count, 2, "DataSource should contain two elements")
        }
    }

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }
}
