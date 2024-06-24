//
//  LoadingViewModel.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 21/06/24.
//

import SwiftUI
import Combine

class LoadingViewModel: ObservableObject {
    @Published var currentFrameIndex = 0
    private var timer: Timer?
    
    let animationFrames: [String] = (1..<9).map { "loadScreen\($0)" }
    
    func startAnimation() {
        stopAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentFrameIndex = (self.currentFrameIndex + 1) % self.animationFrames.count
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
