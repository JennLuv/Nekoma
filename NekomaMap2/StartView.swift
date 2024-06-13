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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image("StartButton")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .onTapGesture {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isGameStarted = true
                        isLoading = false
                    }
                }
        }
        .ignoresSafeArea()
    }
}

