//
//  LoadingView.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 13/06/24.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var displayedText = ""
        private let fullText = "Generating Dungeon . . ."
        private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    @StateObject private var viewModel = LoadingViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack{
                let currentImage = viewModel.animationFrames[viewModel.currentFrameIndex]
                Image(currentImage)
                Text(displayedText)
                    .font(Font.custom("04b", size: 22, relativeTo: .title))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            updateText()
        }
        .onAppear {
            viewModel.startAnimation()
            displayedText = ""
        }
        .onDisappear {
            viewModel.stopAnimation()
        }
        .ignoresSafeArea()
        
    }
    
    private func updateText() {
        // print("updateText")
            if displayedText.count < fullText.count {
                let nextIndex = fullText.index(fullText.startIndex, offsetBy: displayedText.count)
                displayedText += String(fullText[nextIndex])
            } else {
                timer.upstream.connect().cancel() // Stop the timer once the full text is displayed
            }
        }
}

#Preview {
    LoadingView()
}
