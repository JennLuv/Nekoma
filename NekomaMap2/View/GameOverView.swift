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
    @AppStorage("currentRoom") var currentRoomNum: Int = 0
    @AppStorage("enemyKilled") var enemyKilled: Int = 0
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
            ZStack {
                
                VStack{
                    HStack {
                        VStack{
                            Text("ROOM OF DEATH")
                                .font(Font.custom("PixelifySans-Regular", size: 18, relativeTo: .title))
                            Text("ROOM \(currentRoomNum)")
                                .font(Font.custom("PixelifySans-Regular_Bold", size: 23, relativeTo: .title))
                        }
                        .frame(width: 140)
                        Spacer()
                        HStack {
                            VStack{
                                Text("ENEMIES KILLED")
                                    .font(Font.custom("PixelifySans-Regular", size: 18, relativeTo: .title))
                                Text("\(enemyKilled) ENEMIES")
                                    .font(Font.custom("PixelifySans-Regular_Bold", size: 23, relativeTo: .title))
                            }
                            .frame(width: 140)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.horizontal, 30)
                .ignoresSafeArea()
                
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
                            .onTapGesture {
                                isGameOver = false
                                isGameStarted = false
                                soundManager.playSound(fileName: ButtonSFX.start)
                                soundManager.stopSound(fileName: isVictory ? BGM.victory : BGM.death)
                            }
                    }
                }.padding(50)
            }
        }.onAppear {
            soundManager.playSound(fileName: isVictory ? BGM.victory : BGM.death, loop: true)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    @State static var isGameStarted = false
    @State static var isLoading = false
    @State static var isGameOver = true
    @State static var isVictory = false

    static var previews: some View {
        GameOverView(isGameStarted: $isGameStarted, isLoading: $isLoading, isGameOver: $isGameOver, isVictory: $isVictory)
            .environment(\.colorScheme, .dark)
    }
}
