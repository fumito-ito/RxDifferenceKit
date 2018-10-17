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
    func testCollectionViewSectionedReloadDataSource_optionalConfigureSupplementaryView() {

        let dataSource = DifferentiableSectionedCollecitonViewDataSource<Section>(configureCell: { _, _, _, _  in UICollectionViewCell() })
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
        let dataSource = DifferentiableSectionedCollecitonViewDataSource<Section>(configureCell: { _, _, _, _  in UICollectionViewCell() })
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
        let dataSource = DifferentiableSectionedCollecitonViewDataSource<Section>(
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
        let dataSource = DifferentiableSectionedCollecitonViewDataSource<Section>(
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
        let dataSource = DifferentiableSectionedCollecitonViewDataSource<Section>(
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
