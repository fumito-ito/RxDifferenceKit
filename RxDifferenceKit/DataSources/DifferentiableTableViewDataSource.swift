//
//  DifferentiableTableViewDataSource.swift
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

open class DifferentiableTableViewDataSource<S: Differentiable> : NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    public typealias Element = [S]
    public typealias ConfigureCell = (DifferentiableTableViewDataSource<S>, UITableView, IndexPath, S) -> UITableViewCell
    public typealias TitleForHeaderInSection = (DifferentiableTableViewDataSource<S>, Int) -> String?
    public typealias TitleForFooterInSection = (DifferentiableTableViewDataSource<S>, Int) -> String?
    public typealias CanEditRowAtIndexPath = (DifferentiableTableViewDataSource<S>, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (DifferentiableTableViewDataSource<S>, IndexPath) -> Bool

    public typealias SectionIndexTitles = (DifferentiableTableViewDataSource<S>) -> [String]?
    public typealias SectionForSectionIndexTitle = (DifferentiableTableViewDataSource<S>, _ title: String, _ index: Int) -> Int

    public let configuration: DifferentiableDataSourceConfiguration<S>

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

    open var titleForHeaderInSection: TitleForHeaderInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var titleForFooterInSection: TitleForFooterInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var canEditRowAtIndexPath: CanEditRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var sectionIndexTitles: SectionIndexTitles {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var sectionForSectionIndexTitle: SectionForSectionIndexTitle {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }

        return self._items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.section == 0 && indexPath.item < self._items.count)

        return configureCell(self, tableView, indexPath, self[indexPath.row])
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
        let sourceItem = self._items.remove(at: sourceIndexPath.row)
        self._items.insert(sourceItem, at: destinationIndexPath.row)
    }

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles(self)
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle(self, title, index)
    }

    public func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<Element>) {
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
