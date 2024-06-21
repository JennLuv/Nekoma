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
                    soundManager.playSound(fileName: "start")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        soundManager.stopSound(fileName: "homescreen")
                        isGameStarted = true
                        isLoading = false
                    }
                }
                .onAppear {
                    viewModel.startAnimation()
                    soundManager.playSound(fileName: "homescreen", loop: true)
                }
                .onDisappear {
                    viewModel.stopAnimation()
                    soundManager.stopSound(fileName: "homescreen")
                }
            
        }
        .ignoresSafeArea()
    }
}
