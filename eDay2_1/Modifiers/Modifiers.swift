//
//  Modifiers.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/5.
//

import SwiftUI

struct ShadowModifier:ViewModifier{
    func body(content:Content)->some View{
        content
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

struct FontModifier:ViewModifier{
    var style:Font.TextStyle = .body
    func body(content:Content)->some View{
        content
            .font(.system(style,design: .rounded))
    }
}
