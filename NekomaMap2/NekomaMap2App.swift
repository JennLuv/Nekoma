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
    @AppStorage("isGameOver") var isGameOver: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
            } else if isGameOver {
                GameOverView(isGameStarted: $isGameStarted, isLoading: $isLoading, isGameOver: $isGameOver)
            } else if isGameStarted {
                ContentView()
            }  else {
                StartView(isGameStarted: $isGameStarted, isLoading: $isLoading)
            }
        }
    }
}
