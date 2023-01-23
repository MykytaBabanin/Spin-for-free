//
//  MenuViewController.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 18.01.2023.
//

import UIKit

class MenuViewController: UIViewController, UINavigationControllerDelegate {
    weak var coordinator: BaseCoordinator?
    
    @IBOutlet private weak var gameCollectionView: UICollectionView!
    @IBOutlet private weak var currentCashLabel: UILabel!

    private var viewModel: MenuViewModel?
    private let cellIdentifier = "gameCell"
    private let imageData = [UIImage(named: "thunder_game"),
                                 UIImage(named: "fire_game")]
    private var colorData: [CAGradientLayer] = []
    
    private var currentCash: Int

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLabel()
    }
    
    init(viewModel: MenuViewModel, currentCash: Int) {
        self.currentCash = currentCash
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setupCollectionView() {
        gameCollectionView.backgroundColor = .clear
        
        gameCollectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        currentCashLabel.text = "\(currentCash)"
    }
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GameCollectionViewCell
        cell.customizeGameCell(cell: cell, indexPath: indexPath)
        cell.setup(arrayOfImages: imageData, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.playGame(indexPath: indexPath)
    }
}
 
