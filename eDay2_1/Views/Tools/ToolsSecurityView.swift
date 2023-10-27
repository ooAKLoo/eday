//
//  ToolsView.swift
//  EditText
//
//.
//

import SwiftUI
import Vision


struct ToolsSecurityView: View {
    @Binding var backColor:Color
    @State var openImage:Bool=false
    @State var openEassy:Bool=false
    
    @EnvironmentObject var authenticationManager:AuthenicationManager
    

    var body: some View {
        ZStack{
            backColor
            VStack (spacing:50){
//               RectangleButton(imageName: .constant("return.left"))
//                    .cornerRadius(30)
                CircleButton(imageName: .constant("return.left"))
                    .onTapGesture {
                        self.authenticationManager.authenticateOut()
                    }
                CircleButton(imageName: .constant("photo.on.rectangle.angled"))
                    .onTapGesture {
                        self.openImage=true
                    }
                
                CircleButton(imageName: .constant("doc.on.doc"))
                    .onTapGesture {
                        self.openEassy=true
                    }
            
            }
            if openImage{
                Color.white.edgesIgnoringSafeArea(.all)
                ToolsSecurityImageView(showImage: $openImage)
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
            }
            if openEassy{
                Color.white.edgesIgnoringSafeArea(.all)
                ToolsSecurityEassyView(showEassy: $openEassy)
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToolsSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsSecurityView(backColor: .constant(Color(#colorLiteral(red: 0.8688682914, green: 0.9196055532, blue: 0.9847239852, alpha: 1))))
            .environmentObject(AuthenicationManager())
    }
}

struct CircleButton: View {
    @State var tap = false
    @State var press=false
    @Binding var imageName:String
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 44,weight: .light))
        }
        .frame(width: 100, height: 100)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)),Color(#colorLiteral(red: 0.9210464358, green: 0.9353298545, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .stroke(Color.clear,lineWidth: 10)
                    .shadow(color: Color(#colorLiteral(red: 0.9210464358, green: 0.9353298545, blue: 1, alpha: 1)), radius: 3, x: -5, y: -5)
                Circle()
                    .stroke(Color.clear,lineWidth: 10)
                    .shadow(color: Color.white, radius: 3, x: 3, y: 3)
            }
            
        )
        .clipShape(Circle())
        .shadow(color: Color(#colorLiteral(red: 0.8688682914, green: 0.9196055532, blue: 0.9847239852, alpha: 1)), radius: 20, x: 20, y: 20)
    }
}

struct RectangleButton: View {
    @State var tap = false
    @State var press=false
    @Binding var imageName:String
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 44,weight: .light))
        }
        .frame(width: 100, height: 100)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)),Color(#colorLiteral(red: 0.9210464358, green: 0.9353298545, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                Rectangle()
                    .stroke(Color.clear,lineWidth: 10)
                    .shadow(color: Color(#colorLiteral(red: 0.9210464358, green: 0.9353298545, blue: 1, alpha: 1)), radius: 30, x: -5, y: -5)
                Rectangle()
                    .stroke(Color.clear,lineWidth: 10)
                    .shadow(color: Color.gray, radius: 30, x: 30, y: -30)
            }
            
        )
//        .clipShape(Circle())
        .shadow(color: Color(.gray), radius: 20, x: 20, y: 20)
    }
}
