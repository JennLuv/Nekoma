//
//  GameOverView.swift
//  NekomaMap2
//
//  Created by Brendan Alexander Soendjojo on 24/06/24.
//

import SwiftUI

struct GameOverView: View {
    @Binding var isGameStarted: Bool
    @Binding var isLoading: Bool
    @Binding var isGameOver: Bool
    @Binding var isVictory: Bool
    @StateObject private var viewModel = GameOverViewModel()
    var soundManager = SoundManager()
    
    var body: some View {
        ZStack {
            Color("darkBlue").ignoresSafeArea()
            let animationFrame = isVictory ? viewModel.winAnimationFrames[viewModel.winFrameIndex] : viewModel.deathAnimationFrames[viewModel.deathFrameIndex]
            VStack {
                Image("spotlight")
                Spacer()
            }
            VStack {
                Image(isVictory ? "victory":"gameOver")
                    .padding(15)
                Spacer()
                Image(animationFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .onAppear {
                        viewModel.startAnimation(isVictory: isVictory)
                    }
                Image("playAgain")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 20)
                    .padding(.bottom, 20)
                HStack(spacing: 70) {
                    Image("yes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 81, height: 27)
                        .padding(.top, 4)
                        .onTapGesture {
                            isGameOver = false
                            isLoading = true
                            soundManager.playSound(fileName: ButtonSFX.start)
                            soundManager.stopSound(fileName: isVictory ? BGM.victory : BGM.death)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isGameStarted = true
                                isLoading = false
                            }
                        }
                    Image("no")
                        .resizable()
                        .frame(width: 50, height: 20)
                        .scaledToFit()
                        .onTapGesture {
                            isGameOver = false
                            isGameStarted = false
                            soundManager.playSound(fileName: ButtonSFX.start)
                            soundManager.stopSound(fileName: isVictory ? BGM.victory : BGM.death)
                        }
                }
            }.padding(50)
        }.onAppear {
            soundManager.playSound(fileName: isVictory ? BGM.victory : BGM.death, loop: true)
        }
    }
}

//#Preview {
//    GameOverView()
//}
