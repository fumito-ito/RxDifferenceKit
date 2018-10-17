//
//  RowAnimation.swift
//  RxDifferenceKit
//
//  Created by svpcadmin on 2018/10/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import UIKit

public struct RowAnimation {
    public let insertRowAnimation: UITableView.RowAnimation
    public let reloadRowAnimation: UITableView.RowAnimation
    public let deleteRowAnimation: UITableView.RowAnimation
    public let insertSectionAnimation: UITableView.RowAnimation
    public let reloadSectionAnimation: UITableView.RowAnimation
    public let deleteSectionAnimation: UITableView.RowAnimation

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
