//
//  GameDataManager.swift
//  jackTheGiant
//
//  Created by Leon on 14/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import Foundation

// Uses GamaData Class to manage score
class GameDataManager {
    
    // Singleton pattern instance created in class, refer to GameDataManager.instance
    static let instance = GameDataManager()

    // Cannot be init outside class
    fileprivate init() {}
    fileprivate var gameData: GameData?
    
    var gameStartedFromMainMenu = false
    var gameRestartedPlayerDied = false
    
    /// If no game data file exists, save new initial values
    func initializeGameData() {
        
        if !FileManager.default.fileExists(atPath: getFilePath() as String) {
            
            // Init GameData singleton and set scores and settings
            gameData = GameData()
            
            gameData?.setEasyDifficultyScore(0)
            gameData?.setEasyDifficultyCoinScore(0)
            gameData?.setMediumDifficultyScore(0)
            gameData?.setMediumDifficultyCoinScore(0)
            gameData?.setHardDifficultyScore(0)
            gameData?.setHardDifficultyCoinScore(0)
            
            gameData?.setEasyDifficulty(false)
            gameData?.setMediumDifficulty(true)
            gameData?.setHardDifficulty(false)
            gameData?.setIsMusicOn(true)
            
            saveData()
        } else {
            loadData()
        }
        
    }
    
    // Calls Game data decoder
    func loadData() {
        gameData = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath() as String) as? GameData!
    }
    
    // Calls Game data encoder
    func saveData() {
        if gameData != nil {
            NSKeyedArchiver.archiveRootObject(gameData!, toFile: getFilePath() as String)
        }
    }
    
    fileprivate func getFilePath() -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        return url!.appendingPathComponent("Game Data").path
    }
    
    // MARK: Get/Set GameData
    func setEasyDifficultyScore(_ easyDifficultyScore: Int32) {
        gameData!.setEasyDifficultyScore(easyDifficultyScore)
    }
    
    func setEasyDifficultyCoinScore(_ easyDifficultyCoinScore: Int32) {
        gameData!.setEasyDifficultyCoinScore(easyDifficultyCoinScore)
    }
    
    func getEasyDifficultyScore() -> Int32 {
        return gameData!.getEasyDifficultyScore()
    }
    
    func getEasyDifficultyCoinScore() -> Int32 {
        return gameData!.getEasyDifficultyCoinScore()
    }
    
    func setMediumDifficultyScore(_ mediumDifficultyScore: Int32) {
        gameData!.setMediumDifficultyScore(mediumDifficultyScore)
    }
    
    func setMediumDifficultyCoinScore(_ mediumDifficultyCoinScore: Int32) {
        gameData!.setMediumDifficultyCoinScore(mediumDifficultyCoinScore)
    }
    
    func getMediumDifficultyScore() -> Int32 {
        return gameData!.getMediumDifficultyScore()
    }
    
    func getMediumDifficultyCoinScore() -> Int32 {
        return gameData!.getMediumDifficultyCoinScore()
    }
    
    func setHardDifficultyScore(_ hardDifficultyScore: Int32) {
        gameData!.setHardDifficultyScore(hardDifficultyScore)
    }
    
    func setHardDifficultyCoinScore(_ hardDifficultyCoinScore: Int32) {
        gameData!.setHardDifficultyCoinScore(hardDifficultyCoinScore)
    }
    
    func getHardDifficultyScore() -> Int32 {
        return gameData!.getHardDifficultyScore()
    }
    
    func getHardDifficultyCoinScore() -> Int32 {
        return gameData!.getHardDifficultyCoinScore()
    }
    
    func setEasyDifficulty(_ easyDifficulty: Bool) {
        gameData!.setEasyDifficulty(easyDifficulty)
    }
    
    func getEasyDifficulty() -> Bool {
        return gameData!.getEasyDifficulty()
    }
    
    func setMediumDifficulty(_ mediumDifficulty: Bool) {
        gameData!.setMediumDifficulty(mediumDifficulty)
    }
    
    func getMediumDifficulty() -> Bool {
        return gameData!.getMediumDifficulty()
    }
    
    func setHardDifficulty(_ hardDifficulty: Bool) {
        gameData!.setHardDifficulty(hardDifficulty)
    }
    
    func getHardDifficulty() -> Bool {
        return gameData!.getHardDifficulty()
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        gameData!.setIsMusicOn(isMusicOn)
    }
    
    func getIsMusicOn() -> Bool {
        return gameData!.getIsMusicOn()
    }
    
}
