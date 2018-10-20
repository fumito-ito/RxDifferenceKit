//
//  DifferentiableCollectionViewDataSource.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/13.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import DifferenceKit

/// Reactive UICollectionViewDatasource with `Differentiable`s
open class DifferentiableCollectionViewDataSource<S: DifferentiableSection> : NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {

    public typealias Element = [S]

    public typealias ConfigureCell = (DifferentiableCollectionViewDataSource<S>, UICollectionView, IndexPath, S) -> UICollectionViewCell
    public typealias ViewForSupplementaryElementOfKind = (DifferentiableCollectionViewDataSource<S>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    public typealias CanMoveRowAtIndexPath = (DifferentiableCollectionViewDataSource<S>, IndexPath) -> Bool
    public typealias IndexTitles = (DifferentiableCollectionViewDataSource<S>) -> [String]?
    public typealias IndexPathForIndexTitle = (DifferentiableCollectionViewDataSource<S>, _ title: String, _ index: Int) -> IndexPath

    /// configuration for data source
    public let configuration: DifferentiableDataSourceConfiguration<S>

    /// Initializer for UICollectionViewDataSource with `Differentiable`
    ///
    /// - Parameters:
    ///   - configureCell: handler for `collectionView(_:cellForItemAt:)`
    ///   - viewForSupplementaryElementOfKind: handler for `collectionView(_:viewForSupplementaryElementOfKind:at:)`, default value is `nil`
    ///   - canMoveRowAtIndexPath: handler for `collectionView(_:canMoveItemAt:)`, default value is `{ _, _ in false }`
    ///   - indexTitles: handler for `indexTitles(for:)`, default value is `{ _ in nil }`
    ///   - indexPathForIndexTitle: handler for `collectionView(_:indexPathForIndexTitle:at:)`, default value is `nil`
    ///   - configuration: configuration for data source, default value is `DifferentiableDataSourceConfiguration.default`
    public init(
        configureCell: @escaping ConfigureCell,
        viewForSupplementaryElementOfKind: ViewForSupplementaryElementOfKind? = nil,
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        indexTitles: @escaping IndexTitles = { _ in nil },
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

    /// current items for data source
    open var items: [S] {
        return self._items
    }

    open subscript(index: Int) -> S {
        return self._items[index]
    }

    /// update items for data source
    ///
    /// This method just update *data source*, do not update collectionView.
    /// If you need to update tableView, run `collectionView.reloadData()` or etc.
    ///
    /// - Parameter items: new items for data source
    open func setItems(_ items: [S]) {
        self._items = items
    }

    /// handler for `collectionView(_:cellForItemAt:)`
    open var configureCell: ConfigureCell {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `collectionView(_:viewForSupplementaryElementOfKind:at:)`
    open var viewForSupplementaryElementOfKind: ViewForSupplementaryElementOfKind? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `collectionView(_:canMoveItemAt:)`
    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `indexTitles(for:)`
    open var indexTitles: IndexTitles {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `collectionView(_:indexPathForIndexTitle:at:)`
    open var indexPathForIndexTitle: IndexPathForIndexTitle? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    // MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        precondition(section == 0)

        return self._items.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        precondition(indexPath.item < self._items.count)

        return self.configureCell(self, collectionView, indexPath, self.items[indexPath.item])
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.viewForSupplementaryElementOfKind!(self, collectionView, kind, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.canMoveRowAtIndexPath(self, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = self._items.remove(at: sourceIndexPath.item)
        self._items.insert(sourceItem, at: destinationIndexPath.item)
    }

    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return self.indexTitles(self)
    }

    open func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[S]>) {
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
