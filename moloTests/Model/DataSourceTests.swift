import Foundation
import XCTest
@testable import molo

@available(macOS 10.15, iOS 13.0, *)
class DataSourceTests: XCTestCase {
    var dataSource: DataSource!

    override func setUp() {
        super.setUp()
        dataSource = DataSource()
    }

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    func testFetchData() {
        let expectation = self.expectation(description: "Fetch data")
        dataSource.fetchData(of: ["SH601231", "SZ000651"]) { data in
            XCTAssertEqual(data.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
