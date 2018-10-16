//
//  Collection+Extensions.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation

extension Collection where Self.Index == Int {
    mutating func remove(at: Self.Index) -> Self {
        let prefix = self.prefix(upTo: at)
        let suffix = self.suffix(from: at + 1)
        let removed = self[at...at]

        self = [prefix, suffix].joined() as! Self

        return removed as! Self
    }

    mutating func insert(at: Self.Index, with: Self) {
        let prefix = self.prefix(upTo: at) as! Self
        let suffix = self.suffix(from: at) as! Self

        self = [prefix, with, suffix].joined() as! Self
    }
}
