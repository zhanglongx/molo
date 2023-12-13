import Foundation
import XCTest
@testable import molo

@available(macOS 10.15, iOS 13.0, *)
class DataSourceTests: XCTestCase {
    var dataSource: DataSource!

    var model: StockModel!

    override func setUp() {
        super.setUp()

        model = StockModel()
        dataSource = DataSource(with: model)
    }

    override func tearDown() {
        dataSource = nil
        model = nil

        super.tearDown()
    }

    func testfetchData() {
        let expectation = XCTestExpectation(description: "fetchData")

        dataSource.fetchData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(model.stocks[0].price)
        XCTAssertNotNil(model.stocks[0].change)
    }
}
