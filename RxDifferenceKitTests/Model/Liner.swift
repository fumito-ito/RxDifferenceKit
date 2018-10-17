//
//  Liner.swift
//  RxDifferenceKitTests
//
//  Created by Fumito Ito on 2018/10/17.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import DifferenceKit

struct Liner {
    var label: String
}

extension Liner: Differentiable {
    typealias DifferenceIdentifier = String

    var differenceIdentifier: String {
        return self.label
    }

    func isContentEqual(to source: Liner) -> Bool {
        return source.label == self.label
    }
}

extension Liner {
    static func randomize(count: Int) -> [Liner] {
        return []
    }
}
