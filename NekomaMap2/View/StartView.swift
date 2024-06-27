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
    
    @State private var frameIndex = 0
    private let frames = ["playerWalk0", "playerWalk1", "playerWalk2", "playerWalk3"]
    
    func animatePlayer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            frameIndex = (frameIndex + 1) % frames.count
            animatePlayer()
        }
    }
    
    var body: some View {
        
        ZStack {
            // Background
            Color("darkBlue")
                .edgesIgnoringSafeArea(.all)
                
            // Platform
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    // Above Platform Row
                    ForEach(0..<12) { _ in
                        Image("abovePlatform")
                            .resizable()
                            .scaledToFit()
                    }
                }
                HStack(spacing: 0) {
                    // Below Platform Row
                    ForEach(0..<12) { _ in
                        Image("belowPlatform")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            // Player
            VStack {
                HStack {
                    GeometryReader { geometry in
                        Image(frames[frameIndex % frames.count])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .foregroundColor(.black)
                            .padding(.top, 145)
                            .onAppear {
                                animatePlayer()
                            }
                    }
                    Image("neki")
                        .padding(.top, 140)
                }
            }
            
            // Start Button
            VStack {
                Spacer()
                HStack {
                    Image("catFace")
                    VStack {
                        Image("NEKOMAtext")
                        Image("THESTORYtext")
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    isLoading = true
                    soundManager.playSound(fileName: ButtonSFX.start)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        soundManager.stopSound(fileName: BGM.homescreen)
                        isGameStarted.toggle()
                        isLoading = false
                    }
                }) {
                    Image("playButtonYellow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 40)
                        .shadow(radius: 10)
                }
                .onAppear {
                    soundManager.playSound(fileName: BGM.homescreen, loop: true)
                }
                .onDisappear {
                    soundManager.stopSound(fileName: BGM.homescreen)
                }
                Spacer()
            }

        }
        
    }

}
