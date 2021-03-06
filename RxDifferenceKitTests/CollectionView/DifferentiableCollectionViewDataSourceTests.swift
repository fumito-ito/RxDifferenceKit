//
//  DifferentiableCollectionViewDataSourceTests.swift
//  RxDifferenceKitTests
//
//  Created by Fumito Ito on 2018/10/17.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import XCTest
import DifferenceKit

class DifferentiableCollectionViewDataSourceTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
}

extension DifferentiableCollectionViewDataSourceTests {
    func testCollectionViewDataSource_duplicatableData() {
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(configureCell: { _, _, _, _ in UICollectionViewCell() })

        let initialLiners = (0...5).map({ number in Liner.init(label: "\(number)") })
        let secondaryLiners = (0...5).map({ number in Liner.init(label: "\(number)") }) + (0...5).map({ number in Liner.init(label: "\(number)") })

        dataSource.setItems(initialLiners)
        XCTAssertEqual(dataSource.items.count, initialLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: initialLiners[0]), "\(dataSource.items[0]) and \(initialLiners[0]) do not have content equality.")

        dataSource.setItems(secondaryLiners)
        XCTAssertEqual(dataSource.items.count, secondaryLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: secondaryLiners[0]), "\(dataSource.items[0]) and \(secondaryLiners[0]) do not have content equality.")
    }

    func testCollectionViewDataSource_uniqueData() {
        let configuration = DifferentiableDataSourceConfiguration<Liner>.init(rowAnimation: RowAnimation(), duplicationPolicy: .unique(handler: DuplicationPolicy.uniqueHandler))
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(configureCell: { _, _, _, _ in UICollectionViewCell() }, configuration: configuration)

        let initialLiners = (0...5).map({ number in Liner.init(label: "\(number)") })
        let secondaryLiners = (0...5).map({ number in Liner.init(label: "\(number)") }) + (0...5).map({ number in Liner.init(label: "\(number)") })

        dataSource.setItems(initialLiners)
        XCTAssertEqual(dataSource.items.count, initialLiners.count)
        XCTAssert(dataSource.items[0].isContentEqual(to: initialLiners[0]), "\(dataSource.items[0]) and \(initialLiners[0]) do not have content equality.")

        dataSource.setItems(secondaryLiners)
        XCTAssertEqual(dataSource.items.count, secondaryLiners.count / 2)
        XCTAssert(dataSource.items[0].isContentEqual(to: secondaryLiners[0]), "\(dataSource.items[0]) and \(secondaryLiners[0]) do not have content equality.")
    }

    func testCollectionViewSectionedReloadDataSource_optionalConfigureSupplementaryView() {

        let dataSource = DifferentiableCollectionViewDataSource<Liner>(configureCell: { _, _, _, _  in UICollectionViewCell() })
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        XCTAssertFalse(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))

        let sentinel = UICollectionReusableView()
        dataSource.viewForSupplementaryElementOfKind = { _, _, _, _ in return sentinel }

        let returnValue = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        XCTAssertEqual(returnValue, sentinel)
        XCTAssertTrue(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))
    }

    func testCollectionViewSectionedDataSource_optionalConfigureSupplementaryView() {
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(configureCell: { _, _, _, _  in UICollectionViewCell() })
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        XCTAssertFalse(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))

        let sentinel = UICollectionReusableView()
        dataSource.viewForSupplementaryElementOfKind = { _, _, _, _ in return sentinel }

        let returnValue = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        XCTAssertEqual(returnValue, sentinel)
        XCTAssertTrue(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))
    }
}

// configureSupplementaryView passed through init
extension DifferentiableCollectionViewDataSourceTests {
    func testCollectionViewSectionedAnimatedDataSource_optionalConfigureSupplementaryView_initializer() {
        let sentinel = UICollectionReusableView()
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(
            configureCell: { _, _, _, _  in UICollectionViewCell() },
            viewForSupplementaryElementOfKind: { _, _, _, _ in return sentinel }
        )
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        let returnValue = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        XCTAssertEqual(returnValue, sentinel)
        XCTAssertTrue(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))
    }

    func testCollectionViewSectionedReloadDataSource_optionalConfigureSupplementaryView_initializer() {
        let sentinel = UICollectionReusableView()
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(
            configureCell: { _, _, _, _  in UICollectionViewCell() },
            viewForSupplementaryElementOfKind: { _, _, _, _ in return sentinel }
        )
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        let returnValue = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        XCTAssertEqual(returnValue, sentinel)
        XCTAssertTrue(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))
    }

    func testCollectionViewSectionedDataSource_optionalConfigureSupplementaryView_initializer() {
        let sentinel = UICollectionReusableView()
        let dataSource = DifferentiableCollectionViewDataSource<Liner>(
            configureCell: { _, _, _, _  in UICollectionViewCell() },
            viewForSupplementaryElementOfKind: { _, _, _, _ in return sentinel }
        )
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        let returnValue = dataSource.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        XCTAssertEqual(returnValue, sentinel)
        XCTAssertTrue(dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:))))
    }
}
