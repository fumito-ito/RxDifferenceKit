//
//  ViewController.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DifferenceKit
import RxDifferenceKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame)

        view.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        view.dataSource = self.dataSource
        view.delegate = self

        return view
    }()

    lazy var dataSource: DifferentiableTableViewDataSource<Menu> = {
        let source = DifferentiableTableViewDataSource(configureCell: self.configureCell)

        return source
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func configureCell(dataSource: DifferentiableTableViewDataSource<Menu>,
                               tableView: UITableView,
                               indexPath: IndexPath,
                               menu: Menu) -> UITableViewCell {
        return UITableViewCell(frame: .zero)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
