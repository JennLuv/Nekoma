//
//  StartView.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 13/06/24.
//

import SwiftUI

struct StartView: View {
    @Binding var isGameStarted: Bool
    @Binding var isLoading: Bool
    @StateObject private var viewModel = StartViewModel()
    var soundManager = SoundManager()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            let currentImage = viewModel.animationFrames[viewModel.currentFrameIndex]
            Image(currentImage)
                .onTapGesture {
                    isLoading = true
                    viewModel.stopAnimation()
                    soundManager.playSound(fileName: ButtonSFX.start)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        soundManager.stopSound(fileName: BGM.homescreen)
                        isGameStarted = true
                        isLoading = false
                    }
                }
                .onAppear {
                    viewModel.startAnimation()
                    soundManager.playSound(fileName: BGM.homescreen, loop: true)
                }
                .onDisappear {
                    viewModel.stopAnimation()
                    soundManager.stopSound(fileName: BGM.homescreen)
                }
            
        }
        .ignoresSafeArea()
    }
}
