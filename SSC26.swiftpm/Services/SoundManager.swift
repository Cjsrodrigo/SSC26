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

    /// Chame 1 vez no app launch / primeira tela
    func warmUp() {
        guard !warmedUp else { return }
        warmedUp = true

        do {
            let session = AVAudioSession.sharedInstance()
            // .ambient: respeita o áudio do usuário e não interrompe música
            try session.setCategory(.ambient, options: [.mixWithOthers])
            try session.setActive(true, options: [])

            // Pré-carrega seus SFX mais usados (ajuste nomes/extensões)
            preloadSFX(name: "ClickNext", ext: "mp3")
            preloadSFX(name: "Bell", ext: "mp3")// ou wav
            // preloadSFX(name: "tap", ext: "wav") ...

        } catch {
            print("❌ Audio warmUp error:", error)
        }
    }

    private func preloadSFX(name: String, ext: String) {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            print("❌ SFX não encontrado:", name, ext)
            return
        }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()   // ✅ reduz a travada do primeiro play
            sfxPlayers[name] = p
        } catch {
            print("❌ Erro preload:", error)
        }
    }

    func playSFX(_ name: String) {
        // Reusa player pré-carregado
        sfxPlayers[name]?.play()
    }
}
