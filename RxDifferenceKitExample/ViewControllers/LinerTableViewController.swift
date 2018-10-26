//
//  LinerTableViewController.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import UIKit

class LinerTableViewController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
    }
}
