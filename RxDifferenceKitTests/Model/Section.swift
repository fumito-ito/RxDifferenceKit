//
//  Section.swift
//  RxDifferenceKitTests
//
//  Created by Fumito Ito on 2018/10/17.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import DifferenceKit

struct Section {
    var label: String
    var elements: [Liner]

    init(label: String, elements: [Liner]) {
        self.label = label
        self.elements = elements
    }
}

extension Section: DifferentiableSection {
    init<C>(source: Section, elements: C) where C: Collection, C.Element == Liner {
        self.init(label: source.label, elements: elements as! [Liner])
    }

    func isContentEqual(to source: Section) -> Bool {
        return source.label == self.label
    }

    var differenceIdentifier: String {
        return self.label
    }
}
