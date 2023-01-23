//
//  GameCollectionViewCell.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 19.01.2023.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubview()
        setupAutoLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        contentView.addSubview(imageView)
    }
    
    private func setupAutoLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func setup(arrayOfImages: [UIImage?], indexPath: IndexPath) {
        imageView.image = arrayOfImages[indexPath.row]
    }
    
    func customizeGameCell(cell: GameCollectionViewCell, indexPath: IndexPath) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        if indexPath.row == 0 {
            gradientLayer.colors = [ColorPalette.firstGameStartColor.color.cgColor, ColorPalette.firstGameEndColor.color.cgColor]
            
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        } else {
            gradientLayer.colors = [ColorPalette.secondGameStartColor.color.cgColor, ColorPalette.secondGameEndColor.color.cgColor]
            
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        cell.layer.insertSublayer(gradientLayer, at: 0)
        
        cell.layer.sublayers?.forEach({ layer in
            layer.cornerRadius = 10
        })
    }
}
