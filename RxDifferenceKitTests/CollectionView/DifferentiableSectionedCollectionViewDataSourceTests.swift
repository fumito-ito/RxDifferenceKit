//
//  DifferentiableSectionedCollecitonViewDataSourceTests.swift
//  RxDifferenceKitTests
//
//  Created by Fumito Ito on 2018/10/17.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import XCTest

class DifferentiableSectionedCollectionViewDataSourceTests: XCTestCase {
    var initialSections: [Section] = []
    var secondarySections: [Section] = []

    override func setUp() {
        let initialLiners = (0...5).map({ number in Liner.init(label: "\(number)") })
        let secondaryLiners = (0...5).map({ number in Liner.init(label: "\(number)") }) + (0...5).map({ number in Liner.init(label: "\(number)") })

        self.initialSections = [Section(label: "0", elements: initialLiners), Section(label: "1", elements: secondaryLiners)]
        self.secondarySections = [Section(label: "0", elements: initialLiners), Section(label: "0", elements: initialLiners), Section(label: "1", elements: secondaryLiners)]
    }

    override func tearDown() {
    }
}

extension DifferentiableSectionedCollectionViewDataSourceTests {
    func testSectionedTableViewDataSource_duplicatableData() {
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(configureCell: { _, _, _, _ in UICollectionViewCell() })

        dataSource.setItems(self.initialSections)

        XCTAssertEqual(dataSource.items.count, self.initialSections.count)
        XCTAssertEqual(dataSource.items[0].elements.count, self.initialSections[0].elements.count)

        XCTAssert(dataSource.items[0].isContentEqual(to: self.initialSections[0]),
                  "\(dataSource.items[0]) and \(self.initialSections[0]) do not have content equality.")
        XCTAssert(dataSource.items[0].elements[0].isContentEqual(to: self.initialSections[0].elements[0]),
                  "\(dataSource.items[0].elements[0]) and \(self.initialSections[0].elements[0]) do not have content equality.")

        dataSource.setItems(self.secondarySections)

        XCTAssertEqual(dataSource.items.count, self.secondarySections.count)
        XCTAssertEqual(dataSource.items[0].elements.count, self.secondarySections[0].elements.count)

        XCTAssert(dataSource.items[0].isContentEqual(to: self.secondarySections[0]),
                  "\(dataSource.items[0]) and \(self.secondarySections[0]) do not have content equality.")
        XCTAssert(dataSource.items[0].elements[0].isContentEqual(to: self.secondarySections[0].elements[0]),
                  "\(dataSource.items[0].elements[0]) and \(self.secondarySections[0].elements[0]) do not have content equality.")
    }

    func testSectionedTableViewDataSource_uniqueData() {
        let configuration = DifferentiableDataSourceConfiguration<Section>.init(rowAnimation: RowAnimation(), duplicationPolicy: .unique(handler: DuplicationPolicy.uniqueHandler))
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(configureCell: { _, _, _, _ in UICollectionViewCell() }, configuration: configuration)

        dataSource.setItems(self.initialSections)

        XCTAssertEqual(dataSource.items.count, self.initialSections.count)
        XCTAssertEqual(dataSource.items[0].elements.count, self.initialSections[0].elements.count)

        XCTAssert(dataSource.items[0].isContentEqual(to: self.initialSections[0]),
                  "\(dataSource.items[0]) and \(self.initialSections[0]) do not have content equality.")
        XCTAssert(dataSource.items[0].elements[0].isContentEqual(to: self.initialSections[0].elements[0]),
                  "\(dataSource.items[0].elements[0]) and \(self.initialSections[0].elements[0]) do not have content equality.")

        dataSource.setItems(self.secondarySections)

        XCTAssertEqual(dataSource.items.count, self.secondarySections.count - 1)
        XCTAssertEqual(dataSource.items[0].elements.count, self.secondarySections[0].elements.count)

        XCTAssert(dataSource.items[0].isContentEqual(to: self.secondarySections[0]),
                  "\(dataSource.items[0]) and \(self.secondarySections[0]) do not have content equality.")
        XCTAssert(dataSource.items[0].elements[0].isContentEqual(to: self.secondarySections[0].elements[0]),
                  "\(dataSource.items[0].elements[0]) and \(self.secondarySections[0].elements[0]) do not have content equality.")
    }

    func testCollectionViewSectionedReloadDataSource_optionalConfigureSupplementaryView() {

        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(configureCell: { _, _, _, _  in UICollectionViewCell() })
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
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(configureCell: { _, _, _, _  in UICollectionViewCell() })
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
extension DifferentiableSectionedCollectionViewDataSourceTests {
    func testCollectionViewSectionedAnimatedDataSource_optionalConfigureSupplementaryView_initializer() {
        let sentinel = UICollectionReusableView()
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(
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
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(
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
        let dataSource = DifferentiableSectionedCollectionViewDataSource<Section>(
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
