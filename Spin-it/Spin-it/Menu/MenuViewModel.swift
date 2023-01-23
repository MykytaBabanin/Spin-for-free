//
//  MenuViewModel.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 18.01.2023.
//

import Foundation
import UIKit

enum MenuAction {
    case playGame(indexPath: IndexPath)
    case allGames
    case popularGames
}

class MenuViewModel {
    typealias MenuActionCallback = (MenuAction) -> Void
    var menuAction: MenuActionCallback?
    
    init(menuAction: MenuActionCallback? = nil) {
        self.menuAction = menuAction
    }
    
    func playGame(indexPath: IndexPath) {
        menuAction?(.playGame(indexPath: indexPath))
    }
    
    func allGames() {
        menuAction?(.allGames)
    }
    
    func popularGames() {
        menuAction?(.popularGames)
    }
}
