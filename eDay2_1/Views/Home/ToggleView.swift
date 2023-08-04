//
//  ToggleView.swift
//  eDay2_1
//
//  Created by 杨东举 on 2022/1/24.
//

import SwiftUI

struct ToggleView: View {
    
    @State var isHidden:Bool=true
    
    var body: some View {
        ZStack{
            Capsule().fill(Color("card1")).frame(width: 135, height: 45)
            HStack {
                
                if isHidden{
                    Spacer()
                    Text("Light").foregroundColor(.gray)
                    
                }
                ZStack{
                    
                    Capsule().fill(Color("card3")).frame(width: 60, height: 48)
                    Image(systemName: "moon.fill").resizable().frame(width: 25, height: 25).foregroundColor(.yellow)
                }.onTapGesture {
                    self.isHidden.toggle()
                }
                if !isHidden{
                    Text("Dark").foregroundColor(.gray)
                    Spacer()
                }
                
            }.frame(width: 135, height: 45)
                .animation(.spring())
            
            
        }
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
