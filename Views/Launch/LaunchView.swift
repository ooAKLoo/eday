//
//  LoginView.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/5.
//

import SwiftUI

struct LaunchView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showHome = false
    @StateObject var delegate = NotificationDelegate()
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack(alignment: .top) {
                CoverView()
//                    .transition(.move(edge: .bottom))
//                    .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
            }
//            .animation(isFocused ? .easeOut : nil)
            if showHome{
                Color.white.edgesIgnoringSafeArea(.all)
                Home()
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 1))
//                    .animation(Animation.easeOut(duration: 10).delay(5))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){(_,_) in
            }
            
            UNUserNotificationCenter.current().delegate = delegate
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.showHome.toggle()
            }
        })
//        .onAppear(){
//            DispatchQueue.main.asyncAfter(deadline: .now()+2){
//                self.showHome.toggle()
//            }
//        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

struct CoverView: View {
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    var body: some View {
        VStack {
            VStack(spacing:20) {
                Text("eDay")
                    .font(.system(size: screen.width/5, weight:.bold))
                    .foregroundColor(.white)
                
                
                Text("便捷生活 & 社交整合")
                    .font(.system(size: screen.width/10, weight:.bold))
                    .foregroundColor(.white)
                
                Text("From ooAKLoo")
                    .font(.system(size: screen.width/10, weight:.bold))
                    .foregroundColor(.white)
                
//                Text("From ooAKLoo.")
//                    .font(.system(size: screen.width/10, weight:.bold))
//                    .foregroundColor(.white)
            }
            .padding(.bottom,30)
            
            Text("您可以在我们的app里设置提醒、整合社交资源并有许多工具用来方便您的生活 :)")
                .font(.subheadline)
                .frame(width:250)
                .offset(x:viewState.width/20,y:viewState.height/20)
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.top,250)
        .frame(height:screen.height)
        .frame(maxWidth:.infinity)
        .background(
            ZStack {
                Image("Blob")
                    .offset(x:-150,y:-200)
                    .rotationEffect(Angle(degrees: show ? 360+90: 90))
                    .blendMode(.plusDarker)
                    .animation(.linear(duration:120).repeatForever(autoreverses: false))
                    .onAppear{
                        self.show = true
                    }
                Image("Blob")
                    .offset(x:-200,y:-250)
                    .rotationEffect(Angle(degrees: show ? 360: 0),anchor: .leading)
                    .blendMode(.overlay)
                    .animation(Animation.linear(duration:120).repeatForever(autoreverses: false))
            }
            
        )
        .background(
            Image("Launch_bottom")
                .padding()
                .offset(x:viewState.width/25,y:viewState.height/25),
            alignment: .bottom
        )
        .background(
            Color(#colorLiteral(red: 0.5480396152, green: 0.3086947799, blue: 0.9744215608, alpha: 1))
            
        )
        .clipShape(RoundedRectangle(cornerRadius: 30,style: .continuous))
        .rotation3DEffect(Angle(degrees: 5), axis: (x:viewState.width,y:viewState.height,z:0))
        .scaleEffect(isDragging ? 0.9:1)
        .animation(.timingCurve(0.2,0.8,0.2,1,duration:0.8))
        .gesture(
            DragGesture().onChanged{value in
                self.viewState=value.translation
                self.isDragging = true
            }
                .onEnded{ value in
                    self.viewState = .zero
                    self.isDragging = false
                }
        )
    }
}


