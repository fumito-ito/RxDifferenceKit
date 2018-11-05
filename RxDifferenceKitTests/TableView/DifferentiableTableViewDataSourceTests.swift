//
//  DifferentiableTableViewDataSourceTests.swift
//  RxDifferenceKitTests
//
//  Created by Fumito Ito on 2018/10/17.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import XCTest

class DifferentiableTableViewDataSourceTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testTableViewDataSource_duplicatableData() {
        let dataSource = DifferentiableTableViewDataSource<Liner>(configureCell: { _, _, _, _ in UITableViewCell() })

        let initialLiners = (0...5).map({ number in Liner.init(label: "\(number)") })
        let secondaryLiners = (0...5).map({ number in Liner.init(label: "\(number)") }) + (0...5).map({ number in Liner.init(label: "\(number)") })

        dataSource.setItems(initialLiners)
        XCTAssertEqual(dataSource.items.count, initialLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: initialLiners[0]), "\(dataSource.items[0]) and \(initialLiners[0]) do not have content equality.")

        dataSource.setItems(secondaryLiners)
        XCTAssertEqual(dataSource.items.count, secondaryLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: secondaryLiners[0]), "\(dataSource.items[0]) and \(secondaryLiners[0]) do not have content equality.")
    }

    func testTableViewDataSource_uniqueData() {
        let configuration = DifferentiableDataSourceConfiguration<Liner>.init(rowAnimation: RowAnimation(), duplicationPolicy: .unique(handler: DuplicationPolicy.uniqueHandler))
        let dataSource = DifferentiableTableViewDataSource<Liner>(configureCell: { _, _, _, _ in UITableViewCell() }, configuration: configuration)

        let initialLiners = (0...5).map({ number in Liner.init(label: "\(number)") })
        let secondaryLiners = (0...5).map({ number in Liner.init(label: "\(number)") }) + (0...5).map({ number in Liner.init(label: "\(number)") })

        dataSource.setItems(initialLiners)
        XCTAssertEqual(dataSource.items.count, initialLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: initialLiners[0]), "\(dataSource.items[0]) and \(initialLiners[0]) do not have content equality.")

        dataSource.setItems(secondaryLiners)
        XCTAssertEqual(dataSource.items.count, secondaryLiners.count / 2)
        XCTAssert(dataSource.items[0].isContentEqual(to: secondaryLiners[0]), "\(dataSource.items[0]) and \(secondaryLiners[0]) do not have content equality.")
    }
}
