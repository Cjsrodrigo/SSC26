    //
    //  SpeechService.swift
    //  SSC26
    //
    //  Created by Rodrigo Cont on 09/02/26.
    //

import AVFoundation

@MainActor
final class SpeechService {
    static let shared = SpeechService()
    private let synth = AVSpeechSynthesizer()
    private var warmedUp = false
    private var sessionActivated = false

    init() {}

    func warmUp() {
        guard !warmedUp else { return }
        warmedUp = true
        _ = AVSpeechSynthesisVoice(language: "en-US")
    }

    func speak(_ text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if !self.sessionActivated {
                self.sessionActivated = true
                do { try AVAudioSession.sharedInstance().setActive(true, options: []) } catch {}
            }

            self.synth.stopSpeaking(at: .immediate)
            let u = AVSpeechUtterance(string: t)
            u.voice = AVSpeechSynthesisVoice(language: "en-US")
            u.rate = 0.48
            self.synth.speak(u)
        }
    }
    
    
    func primeForFirstSpeak() {
        // roda uma única vez
        guard warmedUp else { return }
        guard sessionActivated else {
            sessionActivated = true
            do { try AVAudioSession.sharedInstance().setActive(true, options: []) } catch {}
            return
        }

        // ✅ fala algo curtíssimo, volume 0, e deixa terminar (não dá stop)
        let u = AVSpeechUtterance(string: "hi")
        u.voice = AVSpeechSynthesisVoice(language: "en-US")
        u.rate = 0.48
        u.volume = 0.0
        synth.speak(u)
    }
}

