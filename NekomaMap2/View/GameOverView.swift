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
    @StateObject private var viewModel = GameOverViewModel()
    var soundManager = SoundManager()
    
    var body: some View {
        ZStack {
            Color("darkBlue").ignoresSafeArea()
            let deathAnimation = viewModel.animationFrames[viewModel.currentFrameIndex]
            VStack {
                Image("spotlight")
                Spacer()
            }
            VStack {
                Image("gameOver")
                    .padding(15)
                Spacer()
                Image(deathAnimation)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .onAppear {
                        viewModel.startAnimation()
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
                            soundManager.stopSound(fileName: BGM.death)
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
                            soundManager.stopSound(fileName: BGM.death)
                        }
                }
            }.padding(50)
        }.onAppear {
            soundManager.playSound(fileName: BGM.death, loop: true)
        }
    }
}

//#Preview {
//    GameOverView()
//}
