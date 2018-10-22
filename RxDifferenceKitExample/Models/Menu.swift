//
//  Menu.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import DifferenceKit

struct Menu: Differentiable {
    typealias DifferenceIdentifier = String

    var title: String
    var segueReuseIdentifier: String

    var differenceIdentifier: String {
        return self.title
    }

    func isContentEqual(to source: Menu) -> Bool {
        return source.title == self.title
    }

    static func generateMenus() -> [Menu] {
        return [
            Menu(title: "Liner / TableView", segueReuseIdentifier: "linerTable"),
            Menu(title: "Sectioned / TableView", segueReuseIdentifier: "sectionedTable"),
            Menu(title: "Liner / CollectionView", segueReuseIdentifier: "linerCollection"),
            Menu(title: "Sectioned / CollectionView", segueReuseIdentifier: "sectionedCollection")
        ]
    }
}
