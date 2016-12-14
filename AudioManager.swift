//
//  AudioManager.swift
//  jackTheGiant
//
//  Created by Leon on 14/12/16.
//  Copyright © 2016 Leon. All rights reserved.
//

import AVFoundation


class AudioManager {
    // Singleton
    static let instance = AudioManager();
    private init() {}
    
    private var audioPlayer: AVAudioPlayer?;
    
    func playBGMusic() {
        let url = Bundle.main.url(forResource: "Background music", withExtension: "mp3");
        
        var err: NSError?;
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!);
            audioPlayer?.numberOfLoops = -1;
            audioPlayer?.prepareToPlay();
            audioPlayer?.play();
        } catch let err1 as NSError {
            err = err1;
        }
        
        if err != nil {
            print(err?.description as Any);
        }
    }
    
    func stopBGMusic() {
        if (audioPlayer?.isPlaying) != nil {
            audioPlayer?.stop();
        }
    }
    
    func isAudioPlayerInitialized() -> Bool {
        return audioPlayer == nil;
    }
    
}

