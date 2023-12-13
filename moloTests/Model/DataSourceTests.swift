import Foundation
import XCTest
@testable import molo

class DataSourceTests: XCTestCase {
    var dataSource: DataSource!

    var model: StockModel!

    override func setUp() {
        super.setUp()

        model = StockModel()
        dataSource = DataSource()
    }

    override func tearDown() {
        dataSource = nil
        model = nil

        super.tearDown()
    }

    func testfetchData() {
        let expectation = XCTestExpectation(description: "fetchData")

        dataSource.fetchData(model)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(model.stocks[0].price)
        XCTAssertNotNil(model.stocks[0].change)
    }
}
