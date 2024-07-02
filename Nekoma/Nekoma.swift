//
//  NekomaMap2App.swift
//  NekomaMap2
//
//  Created by Jennifer Luvindi on 09/06/24.
//

import SwiftUI

@main
struct MyApp: App {
    @State var isGameStarted = false
    @State var isLoading = false
    @State var isGameOver = false
    @State var isVictory = false
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
            } else if isGameOver {
                GameOverView(isGameStarted: $isGameStarted, isLoading: $isLoading, isGameOver: $isGameOver, isVictory: $isVictory)
            } else if isGameStarted {
                ContentView(isGameOver: $isGameOver, isVictory: $isVictory)
            }  else {
                StartView(isGameStarted: $isGameStarted, isLoading: $isLoading)
            }
        }
    }
}
