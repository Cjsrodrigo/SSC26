//
//  SoundManager.swift
//  SSC26
//
//  Created by Rodrigo Cont on 19/02/26.
//

import AVFoundation

@MainActor
final class AudioSystem: ObservableObject {
    static let shared = AudioSystem()

    private var sfxPlayers: [String: AVAudioPlayer] = [:]
    private var warmedUp = false

    private init() {}

    func warmUp() {
        guard !warmedUp else { return }
        warmedUp = true

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, options: [.mixWithOthers])
            try session.setActive(true, options: [])

            preloadSFX(name: "ClickNext", ext: "mp3")
            preloadSFX(name: "Bell", ext: "mp3")

        } catch {
            print("Audio nao deu warmUp", error)
        }
    }

    private func preloadSFX(name: String, ext: String) {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            print("SFX não encontrado:", name, ext)
            return
        }
        do {
            let play = try AVAudioPlayer(contentsOf: url)
            play.prepareToPlay()
            sfxPlayers[name] = play
        } catch {
            print("Erro preload:", error)
        }
    }

    func playSFX(_ name: String) {
        sfxPlayers[name]?.play()
    }
}
