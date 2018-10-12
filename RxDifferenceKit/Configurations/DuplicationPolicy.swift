//
//  DuplicationPolicy.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import DifferenceKit

public enum DuplicationPolicy<T: Differentiable> {
    case duplicatable
    case unique(handler: ([T]) -> [T])
}
