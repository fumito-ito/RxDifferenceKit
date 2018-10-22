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

    let viewModel = MenuViewModel()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)

        self.viewModel.menus
            .asObservable()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    private func configureCell(dataSource: DifferentiableTableViewDataSource<Menu>,
                               tableView: UITableView,
                               indexPath: IndexPath,
                               menu: Menu) -> UITableViewCell {

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as? TableViewCell else {
            return UITableViewCell(frame: .zero)
        }

        cell.textLabel?.text = menu.title
        cell.segueReuseIdentifier = menu.segueReuseIdentifier

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell, let segueReuseIdentifier = cell.segueReuseIdentifier else {
            return
        }

        self.performSegue(withIdentifier: segueReuseIdentifier, sender: nil)
    }
}
