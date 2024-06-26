//
//  NarrativeView.swift
//  NekomaMap2
//
//  Created by Nur Nisrina on 26/06/24.
//

import SwiftUI

struct NarrativeView: View {
    var soundManager = SoundManager()
    
    @State private var nekoFrameIndex = 0
    private let nekoFrames = ["playerWalk0", "playerWalk1", "playerWalk2", "playerWalk3"]
    
    @State private var nekiFrameIndex = 0
    private let nekiFrames = ["nekiWalk0", "nekiWalk1", "nekiWalk2", "nekiWalk3"]
    
    @State private var narrativeIndex = 0
    private let narratives = ["narrative1", "narrative2", "narrative3"]
    
    @State private var isNekoAnimating = false
    @State private var isNekiAnimating = false

    func animateNeko() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if isNekoAnimating {
                nekoFrameIndex = (nekoFrameIndex + 1) % nekoFrames.count
                animateNeko()
            }
        }
    }
    
    func animateNeki() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if isNekiAnimating {
                nekiFrameIndex = (nekiFrameIndex + 1) % nekiFrames.count
                animateNeki()
            }
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
                
                // Player
                VStack {
                    ZStack {
                        GeometryReader { geometry in
                            Image(nekoFrames[nekoFrameIndex % nekoFrames.count])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .foregroundColor(.black)
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
                
                // Start Button
                ZStack {
                    Spacer()
                    Image(narratives[narrativeIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 750)

                    HStack {
                        Spacer()
                        Button(action: {
                            if narrativeIndex < narratives.count - 1 {
                                narrativeIndex += 1
                            }
                        }) {
                            Image("nextNarrativeButton")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaleEffect(0.7)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 90)
                }
                .padding(.top, 210)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
