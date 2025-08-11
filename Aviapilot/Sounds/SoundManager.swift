import Foundation
import AVFoundation

class SoundManager {
    
    static let instance = SoundManager()
    
    private let audioEngine = AVAudioEngine()
    private var audioPlayers: [AVAudioPlayerNode] = []
    
    func playSound(sound: String, loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: ".mp3") else { return }
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let audioPlayer = AVAudioPlayerNode()
            audioEngine.attach(audioPlayer)
            audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
            try audioEngine.start()
            
            if loop {
                audioPlayer.scheduleFile(audioFile, at: nil, completionHandler: nil)
                audioPlayer.play()
            } else {
                audioPlayer.scheduleFile(audioFile, at: nil, completionHandler: nil)
                audioPlayer.play()
                audioPlayers.append(audioPlayer)
            }
        } catch let error {
            print("Sound not found! \(error.localizedDescription)")
        }
    }
    
    func stopAllSounds() {
        for player in audioPlayers {
            player.stop()
        }
        audioPlayers.removeAll()
    }
}


