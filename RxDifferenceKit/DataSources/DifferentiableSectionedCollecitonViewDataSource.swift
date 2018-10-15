//
//  DifferentiableSectionedCollecitonViewDataSource.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import DifferenceKit

open class DifferentiableSectionedCollecitonViewDataSource<S: DifferentiableSection> : NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType where S.Collection.Index == Int {

    public typealias Element = [S]
    public typealias ConfigureCell = (DifferentiableSectionedCollecitonViewDataSource<S>, UICollectionView, IndexPath, S.Collection.Element) -> UICollectionViewCell
    public typealias ViewForSupplementaryElementOfKind = (DifferentiableSectionedCollecitonViewDataSource<S>, UICollectionView, String, IndexPath) -> UICollectionReusableView

    public typealias CanMoveRowAtIndexPath = (DifferentiableSectionedCollecitonViewDataSource<S>, IndexPath) -> Bool

    public typealias IndexTitles = (DifferentiableSectionedCollecitonViewDataSource<S>) -> [String]?
    public typealias IndexPathForIndexTitle = (DifferentiableSectionedCollecitonViewDataSource<S>, _ title: String, _ index: Int) -> IndexPath

    public let configuration: DifferentiableDataSourceConfiguration<S>

    public init(
        configureCell: @escaping ConfigureCell,
        viewForSupplementaryElementOfKind: ViewForSupplementaryElementOfKind? = nil,
        canMoveRowAtIndexPath: CanMoveRowAtIndexPath? = nil,
        indexTitles: IndexTitles? = nil,
        indexPathForIndexTitle: IndexPathForIndexTitle? = nil,
        configuration: DifferentiableDataSourceConfiguration<S> = DifferentiableDataSourceConfiguration.default
        ) {
        self.configureCell = configureCell
        self.viewForSupplementaryElementOfKind = viewForSupplementaryElementOfKind
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
        self.indexTitles = indexTitles
        self.indexPathForIndexTitle = indexPathForIndexTitle
        self.configuration = configuration
    }

    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    private var dataSourceBound: Bool = false

    private func ensureNotMutatedAfterBinding() {
        assert(!self.dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }

    #endif

    private var _items: [S] = []

    open var items: [S] {
        return self._items
    }

    open subscript(index: Int) -> S {
        return self._items[index]
    }

    open func setItems(_ items: [S]) {
        self._items = items
    }

    open var configureCell: ConfigureCell {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var viewForSupplementaryElementOfKind: ViewForSupplementaryElementOfKind? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var indexTitles: IndexTitles? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var indexPathForIndexTitle: IndexPathForIndexTitle? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    // MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _items.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        precondition(section == 0)

        return self._items[section].elements.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        precondition(indexPath.section < self._items.count && indexPath.item < self._items[indexPath.section].elements.count)

        return self.configureCell(self, collectionView, indexPath, self._items[indexPath.section].elements[indexPath.item])
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.viewForSupplementaryElementOfKind!(self, collectionView, kind, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.canMoveRowAtIndexPath?(self, indexPath) ?? false
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = self._items[sourceIndexPath.section]
        var sourceCollection = source.elements
        let target = sourceCollection.remove(at: sourceIndexPath.item)

        self._items[sourceIndexPath.section] = S(source: source, elements: sourceCollection)

        let destination = self._items[destinationIndexPath.section]
        var destinationCollection = destination.elements
        destinationCollection.insert(at: destinationIndexPath.item, with: target)

        self._items[destinationIndexPath.section] = S(source: destination, elements: destinationCollection)
    }

    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return self.indexTitles?(self)
    }

    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[S]>) {
        Binder(self) { dataSource, newItems in
            #if DEBUG
            self.dataSourceBound = true
            #endif

            guard dataSource.items.count > 0 else {
                dataSource.setItems(newItems)
                collectionView.reloadData()
                return
            }

            let changeset = self.generateChangeset(source: dataSource.items,
                                                   target: newItems,
                                                   with: self.configuration.duplicationPolicy)

            collectionView.reload(using: changeset,
                                  setData: { data in
                                    dataSource.setItems(data)
            })
            }.on(observedEvent)
    }

    private func generateChangeset(source: Element, target: Element, with policy: DuplicationPolicy<S>) -> StagedChangeset<Element> {
        switch policy {
        case .duplicatable:
            return StagedChangeset(source: source, target: target)
        case let .unique(handler):
            let unique = handler(target)
            return StagedChangeset(source: source, target: unique)
        }
    }
}