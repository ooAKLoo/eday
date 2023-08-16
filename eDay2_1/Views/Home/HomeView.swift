//
//  HomeView.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/4.
//
import UIKit
import SwiftUI


struct HomeView: View {
    @Binding var showProfile:Bool
    @State var showUpdate = false
    @Binding var showContent: Bool
    @Binding var showToolsContent: Bool
    @Binding var showToolsSecurityContent: Bool
    @Binding var showTipsConventional:Bool
    @Binding var showAudioNote:Bool
    @Binding var showEat:Bool
    @Binding var backColor:Color
    var observation: NSKeyValueObservation?
    @ObservedObject var time: Time = Time()
    
    @ObservedObject var MedData :MedTips = MedTips(data: initMedData().2,finished: initMedData().0,tolcount: initMedData().1)
    
    
//    @Binding var conOutput:(Int,Int,[Conventional])
    @EnvironmentObject var ConData :ConTips
    
    @EnvironmentObject var authenticationManager:AuthenicationManager
    
    var body: some View {
       ScrollView {
           VStack{
               
                HStack {
                    Text("eDay")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                    
                    AvatarView(showProfile: $showProfile)
                    
                    Button(action: {self.showUpdate.toggle()}){
                        Image(systemName: "bell")
                            .renderingMode(.original)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width:36,height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color:Color.black.opacity(0.1),radius:1,x:0,y:1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    .sheet(isPresented: $showUpdate){
                        ContentView()
                    }
                }
                .padding(.horizontal)
                .padding(.leading,14)
                .padding(.top,-30)
                .padding(.bottom,20)
                
                HStack(spacing: 12.0) {
                    RingView(color1:.purple, color2: .white, width: 44, height: 44, percent: self.time.hour*100/24, show: .constant(true))
                    VStack(alignment: .leading, spacing: 4.0){
                        Text(" day off will").font(.subheadline).fontWeight(.bold)
                        Text("have been spent for ").font(.caption)
                    }
//                    RingView(color1:.purple, color2: .white, width: 44, height: 44, percent: self.time.day*100/365, show: .constant(true))
//                    VStack(alignment: .leading, spacing: 4.0){
//                        Text(" day off will").font(.subheadline).fontWeight(.bold)
//                        Text("have been spend for ").font(.caption)
//                    }
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(20)
                .modifier(ShadowModifier())
                .onTapGesture {
                    time.update()
                }
                
                
                HStack{
                    Text("Tips")
                        .font(.title).bold()
                    Spacer()
                }
                .padding(.leading,30)
                .offset(y:10)
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing:20) {
                        ForEach(sectionData) { item in
                            GeometryReader{ geometry in
                                SectionView(section: item,showLogo: false)
                                    .environmentObject(self.MedData)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX-30) / -20), axis: (x: 0, y: 10, z: 0))
                                    .onTapGesture {
                                        if(item.title=="药" || item.title=="习"){
                                            self.showContent=true
                                            self.backColor=item.color
                                        }
                                        else if(item.title=="常"){
                                            self.showTipsConventional=true
                                            self.backColor=item.color
                                        }
                                    }
                            }
                            .frame(width: 275, height: 275)
                        }
                    }
                    .padding(30)
                    .padding(.bottom,20)
                    .padding(.top,-20)
//                    .padding(.leading,-50)
                    
                }
//                .offset(y:-30)
                
                
                
                HStack{
                    Text("AI Tools")
                        .font(.title).bold()
                    Spacer()
                }
                .padding(.leading,30)
                
//                .offset(y:-80)
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing:20) {
                        ForEach(sectionDataTools) { item in
                            GeometryReader{ geometry in
                                SectionView(section: item)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX-30) / -20), axis: (x: 0, y: 10, z: 0))
                                    .onTapGesture {
                                        if(item.title=="文字提取"){
                                            self.showToolsContent=true
                                            self.backColor=item.color
                                        }
                                        if(item.title=="语音笔记"){
                                            self.showAudioNote=true
                                            self.backColor=item.color
                                        }
                                        if(item.title=="吃"){
                                            self.showEat=true
                                            self.backColor=item.color
                                        }
                                        if(item.title=="保险箱"){
                                            self.backColor=item.color
                                            switch authenticationManager.biometryType{
                                            case .faceID:
                                                Task.init{
                                                    await authenticationManager.authenticateWithBiometrics()
                                                }
                                                
                                            case .touchID:
                                                Task.init{
                                                    await
                                                 authenticationManager.authenticateWithBiometrics()
                                                }
                                            default:
                                                break
                                            }
                                        }
                                    }
                            }
                            .frame(width: 275, height: 275)
                        }
                    }
                    .padding(30)
                    .padding(.bottom,20)
                    .padding(.top,-20)
                    
                }
                .padding(.top,-10)
                
                
                
                HStack{
                    Text("Life")
                        .font(.title).bold()
                    Spacer()
                }
                .padding(.leading,30)
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing:20) {
                        ForEach(sectionDataLife) { item in
                            GeometryReader{ geometry in
                                SectionView(section: item)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX-30) / -20), axis: (x: 0, y: 10, z: 0))
                            }
                            .frame(width: 275, height: 275)
                        }
                    }
                    .padding(30)
                    .padding(.bottom,20)
                    .padding(.top,-20)
                    
                }
               .padding(.top,-10)
                
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top,30)
        .edgesIgnoringSafeArea(.all)
        }
       .padding(-20)
       .padding(.top,20)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showProfile: .constant(false),showContent: .constant(false),showToolsContent: .constant(false), showToolsSecurityContent: .constant(false), showTipsConventional: .constant(false),  showAudioNote: .constant(false),showEat: .constant(false), backColor: .constant(.white))
            .environmentObject(ConTips())
    }
}

struct AvatarView: View {
    @Binding var showProfile:Bool
//    @EnvironmentObject var MedDate:MedTips
    
    var body: some View {
        Button(action:{self.showProfile.toggle() }){
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            
        }
    }
}

struct SectionView: View {
    var section:Topical
    var width:CGFloat=275
    var height:CGFloat=275
    var showLogo:Bool = true
    @EnvironmentObject var MedDate:MedTips
    @EnvironmentObject var ConDate:ConTips
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(section.fontColor)
                Spacer()
                if showLogo == false{
                    if section.title=="药"{
                        
                        RingView(color1:.purple, color2: .white,fontcolor: section.fontColor, width: 44, height: 44, percent: CGFloat(CGFloat(self.MedDate.finished)/CGFloat(self.MedDate.tol)*100), show: .constant(true))
                    }
                    else if section.title=="常"{
                        
                        RingView(color1:.purple, color2: .white,fontcolor: section.fontColor, width: 44, height: 44, percent: CGFloat(CGFloat(self.ConDate.Passed)/CGFloat(self.ConDate.tol)*100), show: .constant(true))
                    }
                    else{
                        RingView(color1:.purple, color2: .white, width: 44, height: 44, percent: 68, show: .constant(true))
                    }
                }
                else{
                    Image(section.logo)
                        
                }
            }
            Text(section.text.uppercased())
                .frame(maxWidth:.infinity,alignment:.leading)
                .foregroundColor(section.fontColor)
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:210)
        }
        .padding(.top,2)
        .padding(.horizontal,20)
        .frame(width: width, height: height)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}
struct Topical:Identifiable{
    var id=UUID()
    var title:String
    var text:String
    var logo:String
    var image:Image
    var color:Color
    var fontColor:Color
}
let sectionData=[
    Topical(title: "常", text: "Conventional", logo: "Logo1", image: Image("TipsConventional"), color: Color(#colorLiteral(red: 1, green: 0.5242310762, blue: 0.4515447617, alpha: 1)), fontColor: .black),
    Topical(title: "习", text: "Working", logo: "Logo1", image: Image("TipsStudy"), color: Color(#colorLiteral(red: 0.9768896699, green: 0.5988429189, blue: 0.5366133451, alpha: 1)), fontColor: .black),
    Topical(title: "药", text: "Medieation", logo: "Logo1", image: Image("TipsMed"), color: Color(#colorLiteral(red: 1, green: 0.7922440767, blue: 0.7701362967, alpha: 1)), fontColor: .black),
    Topical(title: "言", text: "Sentence", logo: "Logo1", image: Image("TipsSentence"), color: Color(#colorLiteral(red: 0.9996878505, green: 0.9310560822, blue: 0.9235754609, alpha: 1)), fontColor: .black),
]

let sectionDataTools=[
    Topical(title: "文字提取", text: "Scan", logo: "Tool", image: Image("ToolsScanning"), color: Color(#colorLiteral(red: 1, green: 0.9055414796, blue: 0.358527422, alpha: 1)), fontColor: .black),
    Topical(title: "保险箱", text: "Security", logo: "Tool", image: Image("ToolsSecurity"), color: Color(#colorLiteral(red: 0.8595539331, green: 0.9918276668, blue: 0.3957497478, alpha: 1)), fontColor: .black),
    Topical(title: "语音笔记", text: "audio Note", logo: "Tool", image: Image("ToolsSecurity"), color: Color(#colorLiteral(red: 0.8595539331, green: 0.9918276668, blue: 0.3957497478, alpha: 1)), fontColor: .black),
    Topical(title: "吃", text: "eat what", logo: "Tool", image: Image("ToolsEat"), color: Color(#colorLiteral(red: 0.9473618865, green: 0.9692221284, blue: 0.230423063, alpha: 1)), fontColor: .black),
]

let sectionDataLife=[
    Topical(title: "读书", text: "books", logo: "Life", image: Image("LifeRead"), color: Color(#colorLiteral(red: 0.4942063689, green: 0.4816209078, blue: 0.7981173992, alpha: 1)), fontColor: .black),
    Topical(title: "音乐", text: "music", logo: "Life", image: Image("LifeMusic"), color: Color(#colorLiteral(red: 0.5033385158, green: 0.4719842076, blue: 1, alpha: 1)), fontColor: .black),
    Topical(title: "视频", text: "watching", logo: "Life", image: Image("LifeVideo"), color: Color(#colorLiteral(red: 0.5807858706, green: 0.7100253701, blue: 1, alpha: 1)), fontColor: .black),
]

