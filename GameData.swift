//
//  GameData.swift
//  jackTheGiant
//
//  Created by Leon on 14/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import Foundation

class GameData: NSObject, NSCoding {
    
    struct Keys {
        
        // Distance Score for each difficulty
        static let EasyDifficultyScore = "EasyDifficultyScore";
        static let MediumDifficultyScore = "MediumDifficultyScore";
        static let HardDifficultyScore = "HardDifficultyScore";
        
        // Coin Score for each difficulty
        static let EasyDifficultyCoinScore = "EasyDifficultyCoinScore";
        static let MediumDifficultyCoinScore = "MediumDifficultyCoinScore";
        static let HardDifficultyCoinScore = "HardDifficultyCoinScore";
        
        // User Settings
        static let EasyDifficulty = "EasyDifficulty";
        static let MediumDifficulty = "MediumDifficulty";
        static let HardDifficulty = "HardDifficulty";
        static let Music = "Music";
    }
    
    fileprivate var easyDifficultyScore = Int32();
    fileprivate var mediumDifficultyScore = Int32();
    fileprivate var hardDifficultyScore = Int32();
    
    fileprivate var easyDifficultyCoinScore = Int32();
    fileprivate var mediumDifficultyCoinScore = Int32();
    fileprivate var hardDifficultyCoinScore = Int32();
    
    fileprivate var easyDifficulty = false;
    fileprivate var mediumDifficulty = false;
    fileprivate var hardDifficulty = false;
    fileprivate var isMusicOn = false;
    
    override init() {}
    
    // MARK: NSCoding
    
    /// Set Game Data values from extracting object's values.
    /// Called by NSKeyedUnarchiver.unarchiveObject in loadFile in Game Manager
    required init?(coder aDecoder: NSCoder) {
        
        self.easyDifficultyScore = aDecoder.decodeInt32(forKey: Keys.EasyDifficultyScore);
        self.easyDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.EasyDifficultyCoinScore);
        
        self.mediumDifficultyScore = aDecoder.decodeInt32(forKey: Keys.MediumDifficultyScore);
        self.mediumDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.MediumDifficultyCoinScore);
        
        self.hardDifficultyScore = aDecoder.decodeInt32(forKey: Keys.HardDifficultyScore);
        self.hardDifficultyCoinScore = aDecoder.decodeInt32(forKey: Keys.HardDifficultyCoinScore);
        
        self.easyDifficulty = aDecoder.decodeBool(forKey: Keys.EasyDifficulty);
        self.mediumDifficulty = aDecoder.decodeBool(forKey: Keys.MediumDifficulty);
        self.hardDifficulty = aDecoder.decodeBool(forKey: Keys.HardDifficulty);
        self.isMusicOn = aDecoder.decodeBool(forKey: Keys.Music);
        
    }

    /// Called by NSKeyedArchiver.archiveRootObject in saveFile in GameDataManager.
    func encode(with aCoder: NSCoder) {
        
        aCoder.encodeCInt(self.easyDifficultyScore, forKey: Keys.EasyDifficultyScore);
        aCoder.encodeCInt(self.easyDifficultyCoinScore, forKey: Keys.EasyDifficultyCoinScore);
        
        aCoder.encodeCInt(self.mediumDifficultyScore, forKey: Keys.MediumDifficultyScore);
        aCoder.encodeCInt(self.mediumDifficultyCoinScore, forKey: Keys.MediumDifficultyCoinScore);
        
        aCoder.encodeCInt(self.hardDifficultyScore, forKey: Keys.HardDifficultyScore);
        aCoder.encodeCInt(self.hardDifficultyCoinScore, forKey: Keys.HardDifficultyCoinScore);
        
        aCoder.encode(self.easyDifficulty, forKey: Keys.EasyDifficulty);
        aCoder.encode(self.mediumDifficulty, forKey: Keys.MediumDifficulty);
        aCoder.encode(self.hardDifficulty, forKey: Keys.HardDifficulty);
        aCoder.encode(self.isMusicOn, forKey: Keys.Music);
        
    }
    
    func setEasyDifficultyScore(_ easyDifficultyScore: Int32) {
        self.easyDifficultyScore = easyDifficultyScore;
    }
    
    func setEasyDifficultyCoinScore(_ easyDifficultyCoinScore: Int32) {
        self.easyDifficultyCoinScore = easyDifficultyCoinScore;
    }
    
    func getEasyDifficultyScore() -> Int32 {
        return self.easyDifficultyScore;
    }
    
    func getEasyDifficultyCoinScore() -> Int32 {
        return self.easyDifficultyCoinScore;
    }
    
    func setMediumDifficultyScore(_ mediumDifficultyScore: Int32) {
        self.mediumDifficultyScore = mediumDifficultyScore;
    }
    
    func setMediumDifficultyCoinScore(_ mediumDifficultyCoinScore: Int32) {
        self.mediumDifficultyCoinScore = mediumDifficultyCoinScore;
    }
    
    func getMediumDifficultyScore() -> Int32 {
        return self.mediumDifficultyScore;
    }
    
    func getMediumDifficultyCoinScore() -> Int32 {
        return self.mediumDifficultyCoinScore;
    }
    
    func setHardDifficultyScore(_ hardDifficultyScore: Int32) {
        self.hardDifficultyScore = hardDifficultyScore;
    }
    
    func setHardDifficultyCoinScore(_ hardDifficultyCoinScore: Int32) {
        self.hardDifficultyCoinScore = hardDifficultyCoinScore;
    }
    
    func getHardDifficultyScore() -> Int32 {
        return self.hardDifficultyScore;
    }
    
    func getHardDifficultyCoinScore() -> Int32 {
        return self.hardDifficultyCoinScore;
    }
    
    func setEasyDifficulty(_ easyDifficulty: Bool) {
        self.easyDifficulty = easyDifficulty;
    }
    
    func getEasyDifficulty() -> Bool {
        return self.easyDifficulty;
    }
    
    func setMediumDifficulty(_ mediumDifficulty: Bool) {
        self.mediumDifficulty = mediumDifficulty;
    }
    
    func getMediumDifficulty() -> Bool {
        return self.mediumDifficulty;
    }
    
    func setHardDifficulty(_ hardDifficulty: Bool) {
        self.hardDifficulty = hardDifficulty;
    }
    
    func getHardDifficulty() -> Bool {
        return self.hardDifficulty;
    }
    
    func setIsMusicOn(_ isMusicOn: Bool) {
        self.isMusicOn = isMusicOn;
    }
    
    func getIsMusicOn() -> Bool {
        return self.isMusicOn;
    }
    
}
