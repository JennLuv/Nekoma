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
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
            } else if isGameStarted {
                ContentView()
            } else {
                StartView(isGameStarted: $isGameStarted, isLoading: $isLoading)
            }
        }
    }
}
