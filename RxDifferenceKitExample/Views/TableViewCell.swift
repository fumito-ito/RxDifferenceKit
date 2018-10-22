//
//  TableViewCell.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    static var reuseIdentifier: String { return "tableViewCell" }

    var segueReuseIdentifier: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
