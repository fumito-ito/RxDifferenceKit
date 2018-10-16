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
}
