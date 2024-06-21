//
//  StartViewModel.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 13/06/24.
//

import SwiftUI
import Combine

class StartViewModel: ObservableObject {
    @Published var currentFrameIndex = 0
    private var timer: Timer?
    
    let animationFrames: [String] = (0..<3).map { "StartButton\($0)" }
    
    func startAnimation() {
        stopAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentFrameIndex = (self.currentFrameIndex + 1) % self.animationFrames.count
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

