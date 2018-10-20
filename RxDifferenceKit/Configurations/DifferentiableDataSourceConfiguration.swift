//
//  DifferentiableDataSourceConfiguration.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import DifferenceKit

/// Configuration for data source
public struct DifferentiableDataSourceConfiguration<T: Differentiable> {
    public let rowAnimation: RowAnimation
    public let duplicationPolicy: DuplicationPolicy<T>

    /// default configuration, use `.automatic` animations and `duplicatable` policy
    public static var `default`: DifferentiableDataSourceConfiguration<T> {
        return DifferentiableDataSourceConfiguration<T>(rowAnimation: RowAnimation(), duplicationPolicy: .duplicatable)
    }
}
