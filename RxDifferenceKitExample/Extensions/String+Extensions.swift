//
//  String+Extensions.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/25.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation

/// This extension is via DataSources/Sources/DataSourcesDemo/Components.swift
/// https://github.com/muukii/DataSources/blob/bda65b92067fafb979fb5ef2e30cb60c24a9881e/Sources/DataSourcesDemo/Components.swift
extension String{
    static func randomEmoji() -> String{
        let range = 0x1F601...0x1F64F
        let ascii = range.lowerBound + Int(arc4random_uniform(UInt32(range.count)))

        var view = UnicodeScalarView()
        view.append(UnicodeScalar(ascii)!)

        let emoji = String(view)

        return emoji
    }
}
