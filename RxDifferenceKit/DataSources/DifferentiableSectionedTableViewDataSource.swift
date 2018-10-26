//
//  DifferentiableSectionedTableViewDataSource.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/03.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import DifferenceKit

/// Reactive UITableViewDatasource with `DifferentiableSection`s
open class DifferentiableSectionedTableViewDataSource<S: DifferentiableSection> : NSObject, UITableViewDataSource, RxTableViewDataSourceType where S.Collection.Index == Int {

    public typealias Element = [S]

    public typealias ConfigureCell = (DifferentiableSectionedTableViewDataSource<S>, UITableView, IndexPath, S.Collection.Element) -> UITableViewCell
    public typealias TitleForHeaderInSection = (DifferentiableSectionedTableViewDataSource<S>, Int) -> String?
    public typealias TitleForFooterInSection = (DifferentiableSectionedTableViewDataSource<S>, Int) -> String?
    public typealias CanEditRowAtIndexPath = (DifferentiableSectionedTableViewDataSource<S>, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (DifferentiableSectionedTableViewDataSource<S>, IndexPath) -> Bool
    public typealias SectionIndexTitles = (DifferentiableSectionedTableViewDataSource<S>) -> [String]?
    public typealias SectionForSectionIndexTitle = (DifferentiableSectionedTableViewDataSource<S>, _ title: String, _ index: Int) -> Int

    /// configuration for data source
    public let configuration: DifferentiableDataSourceConfiguration<S>

    /// Initializer for UITableViewDataSource
    ///
    /// - Parameters:
    ///   - configureCell: handler for `tableView(_:cellForRowAt:)`
    ///   - titleForHeaderInSection: handler for `tableView(_:titleForHeaderInSection:)`, default value is `{ _, _ in nil }`
    ///   - titleForFooterInSection: handler for `tableView(_:titleForFooterInSection:)`, default value is `{ _, _ in nil }`
    ///   - canEditRowAtIndexPath: handler for `tableView(_:canEditRowAt:)`, default value is `{ _, _ in false }`
    ///   - canMoveRowAtIndexPath: handler for `tableView(_:canMoveRowAt:)`, default value is `{ _, _ in false }`
    ///   - sectionIndexTitles: handler for `sectionIndexTitles(for:)`, default value is `{ _ in nil }`
    ///   - sectionForSectionIndexTitle: handler for `tableView(_:sectionForSectionIndexTitle:at:)`, default value is `{ _, _, index in index }`
    ///   - configuration: configuration for data source, default value is `DifferentiableDataSourceConfiguration.default`
    public init(
        configureCell: @escaping ConfigureCell,
        titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
        configuration: DifferentiableDataSourceConfiguration<S> = DifferentiableDataSourceConfiguration.default
        ) {
        self.configureCell = configureCell
        self.titleForHeaderInSection = titleForHeaderInSection
        self.titleForFooterInSection = titleForFooterInSection
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
        self.sectionIndexTitles = sectionIndexTitles
        self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
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
    /// This method just update *data source*, do not update tableView.
    /// If you need to update tableView, run `tableView.reloadData()` or etc.
    ///
    /// - Parameter items: new items for data source
    open func setItems(_ items: [S]) {
        switch self.configuration.duplicationPolicy {
        case .duplicatable:
            self._items = items
        case let .unique(handler):
            self._items = handler(items)
        }
    }

    /// handler for `tableView(_:cellForRowAt:)`
    open var configureCell: ConfigureCell {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `tableView(_:titleForHeaderInSection:)`
    open var titleForHeaderInSection: TitleForHeaderInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `tableView(_:titleForFooterInSection:)`
    open var titleForFooterInSection: TitleForFooterInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `tableView(_:canEditRowAt:)`
    open var canEditRowAtIndexPath: CanEditRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `tableView(_:canMoveRowAt:)`
    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `sectionIndexTitles(for:)`
    open var sectionIndexTitles: SectionIndexTitles {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    /// handler for `tableView(_:sectionForSectionIndexTitle:at:)`
    open var sectionForSectionIndexTitle: SectionForSectionIndexTitle {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return _items.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(section < self._items.count)

        return self._items[section].elements.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.section < self._items.count && indexPath.item < self._items[indexPath.section].elements.count)

        return configureCell(self, tableView, indexPath, self._items[indexPath.section].elements[indexPath.row])
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(self, section)
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection(self, section)
    }

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRowAtIndexPath(self, indexPath)
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRowAtIndexPath(self, indexPath)
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = self._items[sourceIndexPath.section]
        var sourceCollection = source.elements
        let target = sourceCollection.remove(at: sourceIndexPath.row)

        self._items[sourceIndexPath.section] = S(source: source, elements: sourceCollection)

        let destination = self._items[destinationIndexPath.section]
        var destinationCollection = destination.elements
        destinationCollection.insert(at: destinationIndexPath.row, with: target)

        self._items[destinationIndexPath.section] = S(source: destination, elements: destinationCollection)
    }

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles(self)
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle(self, title, index)
    }

    open func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<Element>) {
        Binder(self) { dataSource, newItems in
            #if DEBUG
            self.dataSourceBound = true
            #endif

            guard dataSource.items.count > 0 else {
                dataSource.setItems(newItems)
                tableView.reloadData()
                return
            }

            let changeset = self.generateChangeset(source: dataSource.items,
                                                   target: newItems,
                                                   with: self.configuration.duplicationPolicy)

            tableView.reload(using: changeset,
                             deleteSectionsAnimation: self.configuration.rowAnimation.deleteSectionAnimation,
                             insertSectionsAnimation: self.configuration.rowAnimation.insertSectionAnimation,
                             reloadSectionsAnimation: self.configuration.rowAnimation.reloadSectionAnimation,
                             deleteRowsAnimation: self.configuration.rowAnimation.deleteRowAnimation,
                             insertRowsAnimation: self.configuration.rowAnimation.insertRowAnimation,
                             reloadRowsAnimation: self.configuration.rowAnimation.reloadRowAnimation,
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
