//
//  NarrativeView.swift
//  NekomaMap2
//
//  Created by Nur Nisrina on 26/06/24.
//
import SwiftUI

struct NarrativeView: View {
    @Binding var isGameStarted: Bool
    @Binding var isLoading: Bool
    var soundManager = SoundManager()
    
    @State private var nekoFrameIndex = 0
    private let nekoFrames = ["playerWalk0", "playerWalk1", "playerWalk2", "playerWalk3"]
    
    @State private var nekiFrameIndex = 0
    private let nekiFrames = ["nekiWalk0", "nekiWalk1", "nekiWalk2", "nekiWalk3"]
    
    @State private var fishFrameIndex = 0
    private let fishFrames = ["mackarelCommon", "mackarelRare", "mackarelUncommon", "mackarelRare"]
    
    @State private var rangedFrameIndex = 0
    private let rangedFrames = ["rangedWalk0", "rangedWalk1", "rangedWalk2", "rangedWalk3", "rangedWalk4"]
    
    @State private var narrativeIndex = 0
    private let narratives = ["narrative1", "narrative2", "narrative3"]
    
    @State private var isNekoAnimating = false
    @State private var isNekiAnimating = false
    
    @State private var nekoOffsetX: CGFloat = 0
    @State private var nekiOffsetX: CGFloat = 0
    @State private var fishOffsetX: CGFloat = 0
    @State private var enemyOffsetX: CGFloat = 0


    func animate(frameIndex: Binding<Int>, frames: [String]) {
        // print("animate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            frameIndex.wrappedValue = (frameIndex.wrappedValue + 1) % frames.count
            animate(frameIndex: frameIndex, frames: frames)
        }
    }
    
    func animateNeko() {
        // print("animateNeko")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            nekoFrameIndex = (nekoFrameIndex + 1) % nekoFrames.count
            animateNeko()
        }
    }
    
    func animateNeki() {
        // print("animateNeki")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if isNekiAnimating {
                nekiFrameIndex = (nekiFrameIndex + 1) % nekiFrames.count
                animateNeki()
            }
        }
    }
    
    func moveNeki() {
        // print("moveNeki")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            withAnimation(.linear(duration: 0.06)) {
                nekiOffsetX += 15
                if isNekoAnimating {
                    nekoOffsetX += 1
                }
            }
            moveNeki()
            moveFish()
        }
    }
    
    func moveFish() {
        // print("moveFish")
        withAnimation(.linear(duration: 0.1)) {
            fishOffsetX += CGFloat(Int.random(in: 2...5))
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color("darkBlue")
                    .edgesIgnoringSafeArea(.all)
                
                // Platform
                VStack(spacing: 0) {
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
                
                // Neki Neko
                VStack {
                    ZStack {
                        GeometryReader { geometry in
                            Image(nekoFrames[nekoFrameIndex % nekoFrames.count])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .foregroundColor(.black)
                                .offset(x: nekoOffsetX)
                                .onAppear {
                                    isNekoAnimating = true
                                    animateNeko()
                                }
                                .onDisappear {
                                    isNekoAnimating = false
                                }
                        }
                        .padding(.leading, 30)
                        .padding(.top, 10)
                        GeometryReader { geometry in
                            Image(nekiFrames[nekiFrameIndex % nekiFrames.count])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .foregroundColor(.black)
                                .offset(x: nekiOffsetX)
                                .onAppear {
                                    isNekiAnimating = true
                                    animateNeki()
                                }
                                .onDisappear {
                                    isNekiAnimating = false
                                }
                        }
                    }
                    
                }
                .padding(.leading, 300)
                
                //Fish
                GeometryReader { geometry in
                    Image(fishFrames[fishFrameIndex % fishFrames.count])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 200)
                        .foregroundColor(.black)
                        .offset(x: fishOffsetX)
                        .onAppear {
                            animate(frameIndex: $fishFrameIndex, frames: fishFrames)
                        }
                }
                .padding(.leading, 700)
                .padding(.top, 20)
                
                //Enemies
                if narrativeIndex == 2 {
                    GeometryReader { geometry in
                        Image(rangedFrames[rangedFrameIndex % rangedFrames.count])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .foregroundColor(.black)
                            .offset(x: enemyOffsetX)
                            .onAppear {
                                animate(frameIndex: $rangedFrameIndex, frames: rangedFrames)
                                isNekoAnimating = false
                            }
                    }
                    .padding(.leading, 750)
                    GeometryReader { geometry in
                        Image(rangedFrames[rangedFrameIndex % rangedFrames.count])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .foregroundColor(.black)
                            .offset(x: enemyOffsetX)
                            .onAppear {
                                animate(frameIndex: $rangedFrameIndex, frames: rangedFrames)
                            }
                    }
                    .padding(.leading, 700)
                }
                
                // Start Button
                ZStack {
                    Spacer()
                    Image(narratives[narrativeIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 780)
                        .padding(.top, 30)
                    HStack {
                        Spacer()
                        Button(action: {
                            if narrativeIndex < narratives.count - 1 {
                                narrativeIndex += 1
                                moveNeki()
                            }
                        }) {
                            if narrativeIndex == 2 {
                                Button(action: {
                                    isLoading = true
                                    soundManager.playSound(fileName: ButtonSFX.start)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        soundManager.stopSound(fileName: BGM.homescreen)
                                        isGameStarted.toggle()
                                        isLoading = false
                                    }
                                }) {
                                    Image("xButton")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .scaleEffect(0.7)
                                }
                            } else {
                                Image("nextNarrativeButton")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaleEffect(0.7)
                            }
                        }
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 90)
                }
                .padding(.top, 210)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            soundManager.playSound(fileName: BGM.homescreen, loop: true)
        }
        .onDisappear {
            soundManager.stopSound(fileName: BGM.homescreen)
        }
    }
}
