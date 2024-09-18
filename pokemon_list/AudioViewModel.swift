//
//  AudioViewModel.swift
//  pokemon_list
//
//  Created by Tanmay Gandhi on 22/08/24.
//

import Foundation
import AVFAudio

class AudioViewModel {
    
    var audioPlayer: AVAudioPlayer?

    func setAudio(_ PokNm: String?) {
        
        guard let PokNm = PokNm else { return }

        if let assetURL = Bundle.main.url(forResource: PokNm, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: assetURL)
                play_song()
            } catch {
                print("Error loading audio files: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found in the app's assets.")
        }
        
    }
    
    
    func play_song() {
        
        guard let player = audioPlayer else {
            print("Audio players is nil, cannot play.")
            return
        }
        
        if player.isPlaying {   // Stop Voice
            
            player.stop()
        }
        
        // Run music in backfround
        DispatchQueue.global().async { // Play Voice
            // This is Slow Song
            player.prepareToPlay()
            player.play()
        }
        
    }
}
