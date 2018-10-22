//
//  MenuViewModel.swift
//  RxDifferenceKitExample
//
//  Created by svpcadmin on 2018/10/15.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class MenuViewModel {
    var menus: Observable<[Menu]>

    init() {
        self.menus = Observable.just(Menu.generateMenus())
    }
}
