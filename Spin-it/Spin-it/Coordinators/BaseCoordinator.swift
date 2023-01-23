//
//  BaseCoordinator.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 18.01.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: Router { get set }
    
    func start(currentCash: Int?)
}

class BaseCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: Router
    var currentAmount: Int?
    
    init(navigationController: Router) {
        self.navigationController = navigationController
    }
    
    func start(currentCash: Int? = nil) {
        let viewModel = MenuViewModel { [weak self] action in
            switch action {
            case .allGames: break
            case .popularGames: break
            case .playGame(let indexPath): self?.openGame(indexPath: indexPath)
            }
        }
        let viewController = MenuViewController(viewModel: viewModel, currentCash: currentCash ?? 0)
        viewController.coordinator = self
        navigationController.setRootViewController(viewController)
    }
    
    func openGame(indexPath: IndexPath) {
        let viewController: GameViewController?

        let viewModel = GameViewModel { [weak self] action in
            switch action {
            case .returnToMenu(let currentCash):
                self?.start(currentCash: currentCash)
            }
        }
        
        if indexPath.row == 1 {
            viewController = GameViewController(viewModel: viewModel,
                                                images: [UIImage(named: "rose"),
                                                         UIImage(named: "blue"),
                                                         UIImage(named: "light_blue"),
                                                         UIImage(named: "red")])
        } else {
            viewController = GameViewController(viewModel: viewModel,
                                                images: [
                                                    UIImage(named: "alchemy"),
                                                    UIImage(named: "crystal"),
                                                    UIImage(named: "fire"),
                                                    UIImage(named: "bottle")])
        }
        
        viewController?.coordinator = self
        if let viewController = viewController {
            navigationController.pushViewController(viewController)
        }
    }
    
    func showMainViewControllerWithPush(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController)
    }
    
    func popToRootAndRemoveChilds(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
}


class Router: NSObject {
    private(set) weak var rootController: UINavigationController?
    
    var isOnRootViewController: Bool {
        return rootController?.viewControllers.count == 1
    }
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()
        rootController.delegate = self
    }
    
    func pushViewController(_ viewController: UIViewController) {
        rootController?.pushViewController(viewController, animated: true)
    }
    
    func popToRootViewController(animated: Bool = true) {
        rootController?.popToRootViewController(animated: animated)
    }
    
    func setRootViewController(_ rootViewController: UIViewController?) {
        guard let root = rootViewController else {
            rootController?.setViewControllers([], animated: true)
            return
        }
        
        rootController?.setViewControllers([root], animated: true)
    }
    
    func present(alert: UIAlertController) {
        rootController?.present(alert, animated: true)
    }
    
    func presentMediumPageSheet(_ rootViewController: UIViewController) {
        rootViewController.modalPresentationStyle = .pageSheet
        if let sheet = rootViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        rootController?.present(rootViewController, animated: true)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVc = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(fromVc) else { return }
    }
}
