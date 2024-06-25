//
//  GameOverViewModel.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 24/06/24.
//

import Foundation

class GameOverViewModel: ObservableObject {
    @Published var currentFrameIndex = 0
    private var timer: Timer?
    
    let animationFrames: [String] = (0..<3).map { "playerDeath\($0)" }
    
    func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.currentFrameIndex = (self.currentFrameIndex + 1) % self.animationFrames.count
        }
    }
}
