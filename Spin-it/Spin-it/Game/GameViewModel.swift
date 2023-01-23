//
//  GameViewModel.swift
//  Spin-it
//
//  Created by Mykyta Babanin on 18.01.2023.
//

import UIKit
import AVFAudio

enum GameAction {
    case returnToMenu(currentAmount: Int)
}

class GameViewModel {
    typealias GameActionCallback = (GameAction) -> Void
    var gameAction: GameActionCallback?
    
    var player : AVAudioPlayer?
    
    init(gameAction: GameActionCallback? = nil) {
        self.gameAction = gameAction
    }
    
    func returnToMenu(currentAmount: Int) {
        gameAction?(.returnToMenu(currentAmount: currentAmount))
    }
    
    func updateScore(textView : UITextView, cash amount : Int) {
        textView.text = "\(Int(amount))$"
        UserDefaults.standard.set(amount, forKey: Constant.user_cash)
    }
    
    func getScore() -> Int {
        let cash = UserDefaults.standard.integer(forKey: Constant.user_cash)
        return cash <= 0 ? 500 : cash
    }
    
    func isFirstTime() -> Bool {
        let saveExist = UserDefaults.standard.bool(forKey: Constant.is_save_exist)
        if !saveExist {
            UserDefaults.standard.set(true, forKey: Constant.is_save_exist)
            return true
        }
        return false
    }
    
    func play(sound name : String){
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else{
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}

