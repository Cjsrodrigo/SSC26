//
//  SpeechService.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import AVFoundation

final class SpeechService {
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }

        synth.stopSpeaking(at: .immediate)

        let u = AVSpeechUtterance(string: t)
        u.voice = AVSpeechSynthesisVoice(language: "en-US")
        u.rate = 0.48

        synth.speak(u)
    }
}
