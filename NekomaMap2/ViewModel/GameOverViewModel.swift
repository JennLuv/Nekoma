//
//  GameOverViewModel.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 24/06/24.
//

import Foundation
import SwiftUI

class GameOverViewModel: ObservableObject {
    @Published var deathFrameIndex = 0
    @Published var winFrameIndex = 0
    private var deathTimer: Timer?
    private var winTimer: Timer?

    let deathAnimationFrames: [String] = (0..<3).map { "playerDeath\($0)" }
    let winAnimationFrames: [String] = (0..<4).map { "playerWalk\($0)" }

    func startAnimation(isVictory: Bool) {
        // print("startAnimation")
        if isVictory {
            startWinAnimation()
        } else {
            startDeathAnimation()
        }
    }

    private func startDeathAnimation() {
        // print("startDeathAnimation")
        deathTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.deathFrameIndex = (self.deathFrameIndex + 1) % self.deathAnimationFrames.count
        }
    }

    private func startWinAnimation() {
        // print("startWinAnimation")
        winTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.winFrameIndex = (self.winFrameIndex + 1) % self.winAnimationFrames.count
        }
    }
}
