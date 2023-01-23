//
//  GameViewController.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 18.01.2023.
//

import UIKit

class GameViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    var coordinator: BaseCoordinator?
    
    private let images: [UIImage?]
    
    @IBOutlet private weak var winLabel: UILabel!
    @IBOutlet private weak var cashTextView: UITextView!
    @IBOutlet private weak var spinImageView: UIImageView!
    @IBOutlet private weak var machineImageView: UIImageView!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var cashImageView: UIImageView!
    @IBOutlet private weak var cashToRiskLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    
    private let viewModel: GameViewModel
        
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        setupStyle()
        addGestureRecognizerForTap()
        setupBackButton()
    }
    
    init(viewModel: GameViewModel, images: [UIImage?]) {
        self.viewModel = viewModel
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        view.backgroundColor = .darkGray
        cashTextView.layer.cornerRadius = 5
        setupGradientColor()
    }
    
    private func setupGradientColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cashTextView.bounds
        gradientLayer.colors = [ColorPalette.cashAmountLabelStartColor.color.cgColor, ColorPalette.cashAmountLabelEndColor.color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        cashTextView.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    private var cashToRisk: Int = 10 {
        didSet {
            cashToRiskLabel.text = "\(currentCash)$"
        }
    }
    
    var currentCash: Int {
        guard let cash = cashTextView.text, !(cashTextView.text?.isEmpty)! else {
            return 0
        }
        return Int(cash.replacingOccurrences(of: "$", with: ""))!
    }
    
    private func startGame() {
        if viewModel.isFirstTime(){
            viewModel.updateScore(textView: cashTextView, cash: 500)
        } else {
            cashTextView.text = "\(viewModel.getScore())$"
        }
        stepper.maximumValue = Double(currentCash)
    }
    
    private func roll() {
        var delay : TimeInterval = 0
        
        for i in 0..<pickerView.numberOfComponents {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.randomSelectRow(in: i)
            })
            delay += 0.30
        }
    }
    
    private func randomSelectRow(in component : Int) {
        let random = Int(arc4random_uniform(UInt32(8 * images.count))) + images.count
        pickerView.selectRow(random, inComponent: component, animated: true)
    }
    
    
    private func checkWin() {
        winLabel.isHidden = true
        var lastRow = -1
        var counter = 0
        
        for i in 0..<pickerView.numberOfComponents {
            let row : Int = pickerView.selectedRow(inComponent: i) % images.count
            if lastRow == row {
                counter += 1
            } else {
                lastRow = row
                counter = 1
            }
        }
        
        if counter == 4 {
            viewModel.play(sound: Constant.win_sound)
            stepper.maximumValue = Double(currentCash)
            
            viewModel.updateScore(textView: cashTextView, cash: (currentCash + 200) + (cashToRisk * 2))
            winLabel.isHidden = false
            winLabel.text = "Won +\((200) + (cashToRisk * 2))"
        } else {
            viewModel.updateScore(textView: cashTextView, cash: (currentCash - cashToRisk))
        }
        
        if currentCash <= 0 {
            gameOver()
        } else {
            if Int(stepper.value) > currentCash {
                stepper.maximumValue = Double(currentCash)
                cashToRisk = currentCash
                stepper.value = Double(currentCash)
            }
        }
    }
    
    private func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "You have \(currentCash)$ \nPlay Again?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.startGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func spinAction() {
        viewModel.play(sound: Constant.spin_sound)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
        }
    }
    
    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_back"), style: .done, target: self, action: #selector(returnToMain))
    }
    
    private func addGestureRecognizerForTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        spinImageView.addGestureRecognizer(tapGestureRecognizer)
        spinImageView.isUserInteractionEnabled = true
    }
    
    @objc func returnToMain() {
        viewModel.returnToMenu(currentAmount: currentCash)
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        stepper.maximumValue = Double(currentCash)
        let amount = Int(sender.value)
        if currentCash >= amount{
            cashToRisk = amount
            cashToRiskLabel.text = "\(amount)$"
        }
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        spinAction()
    }
    
    //MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
}
