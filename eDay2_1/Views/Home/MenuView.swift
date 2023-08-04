//
//  MenuView.swift
//  eDay
//
//  Created by 杨东举 on 2021/12/1.
//

import SwiftUI
import UIKit.UIColor


struct MenuView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing:16) {
                Text("Hello AKL")
                
                
                MenuRow(title: "Account",icon: "gear")
                MenuRow(title: "Sign Out",icon: "person.crop.circle")
            }
            .frame(maxWidth:.infinity)
            .frame(height:300)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8954151273, green: 0.9160741568, blue: 0.9564130902, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color:Color.black.opacity(0.2),radius: 20,x:0,y:20)
        .padding(.horizontal,30)
        .overlay(
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .offset(y:-150)
            )
        }
        .padding(.bottom,30)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

struct MenuRow: View {
    var title:String
    var icon:String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .light))
                .imageScale(.large)
                .frame(width: 32, height: 32)
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(width: 120, alignment: .leading)
        }
    }
}
