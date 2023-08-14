//
//  Home.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/4.
//

import SwiftUI

struct Home: View {
    @State var showProfile = false
    @State var viewState = CGSize.zero
    @State var showTipsContent = false
    @State var showToolsContent = false
    @State var showToolsSecurityContent = false
    @State var showTipsConventional = false
    @State var showAudioNote = false
    @State var backColor = Color(.white)
    
    @ObservedObject var ConData :ConTips = initConData()
    
    @StateObject var authenticationManager = AuthenicationManager()
    var body: some View {
        ZStack {
           
            HomeView(showProfile:$showProfile, showContent: $showTipsContent,showToolsContent: $showToolsContent, showToolsSecurityContent: $showToolsSecurityContent ,showTipsConventional: $showTipsConventional,showAudioNote: $showAudioNote, backColor: $backColor)
                .environmentObject(ConData)
                .environmentObject(authenticationManager)
//                .environmentObject(ConData)
            
            
            MenuView()
                .offset(y:showProfile ?0:screen.height)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            if showTipsContent {
                    Color.white.edgesIgnoringSafeArea(.all)
                TipsView(backColor: $backColor, showContent: $showTipsContent)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 0))
                }
            if showTipsConventional{
                Color.white.edgesIgnoringSafeArea(.all)
                TipsConventionalView(backColor: $backColor, showContent: $showTipsConventional)
                    .environmentObject(ConData)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
            }

            if showToolsContent {
                    Color.white.edgesIgnoringSafeArea(.all)
                ToolsView(backColor: $backColor, showContent: $showToolsContent)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
                }
            if showAudioNote {
                Color.white.edgesIgnoringSafeArea(.all)
                SSTView(backColor: $backColor, showSSTView: $showAudioNote) // 如果 SSTView 没有任何参数，这里就直接使用 ()
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 1))
            }

            if authenticationManager.isAuthenticated{
                Color.white.edgesIgnoringSafeArea(.all)
            ToolsSecurityView(backColor: $backColor)
                    .environmentObject(authenticationManager)
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
            }

            }
        .padding(.top,screen.width/10)
        .padding(.leading,0)
//        .frame(width: screen.width)
            
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

let screen = UIScreen.main.bounds
