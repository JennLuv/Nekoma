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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            let currentImage = viewModel.animationFrames[viewModel.currentFrameIndex]
            Image(currentImage)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .onTapGesture {
                    isLoading = true
                    viewModel.stopAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isGameStarted = true
                        isLoading = false
                    }
                }
                .onAppear {
                    viewModel.startAnimation()
                }
                .onDisappear {
                    viewModel.stopAnimation()
                }
            
        }
        .ignoresSafeArea()
    }
}
