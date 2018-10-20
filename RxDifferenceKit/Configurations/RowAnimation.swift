//
//  RowAnimation.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import UIKit

/// Animation configurations for UITableView row updates
public struct RowAnimation {
    /// animation for insert row
    public let insertRowAnimation: UITableView.RowAnimation
    /// animation for reload row
    public let reloadRowAnimation: UITableView.RowAnimation
    /// animation for delete row
    public let deleteRowAnimation: UITableView.RowAnimation
    /// animation for insert section
    public let insertSectionAnimation: UITableView.RowAnimation
    /// animation for reload section
    public let reloadSectionAnimation: UITableView.RowAnimation
    /// animation for delete section
    public let deleteSectionAnimation: UITableView.RowAnimation

    /// Initializer for RowAnimation
    ///
    /// - Parameters:
    ///   - insertRowAnimation: animation for insert row, default value is `.automatic`
    ///   - reloadRowAnimation: animation for reload row, default value is `.automatic`
    ///   - deleteRowAnimation: animation for delete row, default value is `.automatic`
    ///   - insertSectionAnimation: animation for insert section, default value is `.automatic`
    ///   - reloadSectionAnimation: animation for reload section, default value is `.automatic`
    ///   - deleteSectionAnimation: animation for remove section, default value is `.automatic`
    public init(insertRowAnimation: UITableView.RowAnimation = .automatic,
                reloadRowAnimation: UITableView.RowAnimation = .automatic,
                deleteRowAnimation: UITableView.RowAnimation = .automatic,
                insertSectionAnimation: UITableView.RowAnimation = .automatic,
                reloadSectionAnimation: UITableView.RowAnimation = .automatic,
                deleteSectionAnimation: UITableView.RowAnimation = .automatic) {
        self.insertRowAnimation = insertRowAnimation
        self.reloadRowAnimation = reloadRowAnimation
        self.deleteRowAnimation = deleteRowAnimation
        self.insertSectionAnimation = insertSectionAnimation
        self.reloadSectionAnimation = reloadSectionAnimation
        self.deleteSectionAnimation = deleteSectionAnimation
    }
}
