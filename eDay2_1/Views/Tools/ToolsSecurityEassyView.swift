//
//  ToolsSecurityEassyView.swift
//  eDay5
//
//
//

import SwiftUI

struct ToolsSecurityEassyView: View {
    @Binding var showEassy:Bool
    
    @State var showEassySheet:Bool=false
    @State var adddp:Bool=false
    
    @ObservedObject var eassyData:Eassy = Eassy()
    
    
    //    @State var index:Int
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack(spacing:280) {
                        Button(action:{
                            self.adddp.toggle()
                        }){
                            Image(systemName: "plus")
                                .frame(width: 36,height:36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .sheet(isPresented:$adddp){
                            EassySheetView(title: "", text: "")
                                .environmentObject(self.eassyData)
                        }
                        
                        Button(action:{
                            self.showEassy=false
                        }){
                            Image(systemName: "xmark")
                                .frame(width:36,height:36)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.top,70)
                .frame(width: screen.width, height: screen.height/7)
                .background(Color(#colorLiteral(red: 0.9491766095, green: 0.9488013387, blue: 0.9705427289, alpha: 1)))
                
                VStack{
                    List(self.eassyData.EassyList){ite in
                        if !ite.isDeleted{
                            EassyListView(showEassySheet: $showEassySheet, index: ite.id)
                                .environmentObject(self.eassyData)
                        }
                    }
                    .padding(.top,-10)
                }
                .frame(width: screen.width, height: screen.height/8*7)
                
            }.background(.white)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToolsSecurityEassyView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsSecurityEassyView(showEassy: .constant(false))
    }
}

struct EassyListView: View {
    
    @EnvironmentObject var eassyData:Eassy
    @Binding var showEassySheet:Bool
    var index:Int
    
    var body: some View {
        HStack {
            Button(action:{
                                self.eassyData.delete(index: self.index)
            }){
                Image(systemName:"trash")
                    .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                    .padding(.leading,-5)
                
            }
            .buttonStyle(BorderlessButtonStyle())
            Button(action:{
                self.showEassySheet=true
                //                                    index=ite
            }){
                HStack {
                    VStack {
                        HStack {
                            Text("\(eassyData.EassyList[index].title)")
                            Spacer()
                        }
                        HStack {
                            Text("\(modiferDateToStr_date_hm(time: eassyData.EassyList[index].date))")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .frame(width: screen.width-180)
                    .padding(.leading,20)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.blue)
                }
            }
            .foregroundColor(.black)
            .sheet(isPresented:$showEassySheet){
                EassySheetView(title: eassyData.EassyList[index].title, text: eassyData.EassyList[index].text,id: eassyData.EassyList[index].id)
                    .environmentObject(self.eassyData)
            }
        }
    }
}
