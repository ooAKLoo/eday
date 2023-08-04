//
//  RingView.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/5.
//

import SwiftUI

struct RingView: View {
    var color1=(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
    var color2=(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    var fontcolor:Color=Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235))
    var width:CGFloat=44
    var height:CGFloat=44
    var percent: CGFloat=88
    @Binding var show :Bool
    
    var body: some View {
        let multiplier = width/44
        let progress = 1-(percent/100)
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1),style: StrokeStyle(lineWidth:5))
                .frame(width: width, height: height)
            Circle()
                .trim(from: show ?progress : 1 , to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(color1),Color(color2)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                        style: StrokeStyle(lineWidth: 5*multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x:1,y:0,z:0))
                .frame(width: width, height: height)
            .shadow(color: Color(color2).opacity(0.1), radius: 3*multiplier, x: 0, y: 3*multiplier)
            .animation(.easeInOut)
            Text("\(Int(percent))%")
                .font(.system(size: 14*multiplier))
                .fontWeight(.bold)
                .foregroundColor(fontcolor)
                .onTapGesture {
                    self.show.toggle()
                }
            
            
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(show:.constant(true))
    }
}
