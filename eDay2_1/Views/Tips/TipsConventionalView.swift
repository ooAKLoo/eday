//
//  TipsConventionalViews.swift
//  eDay2_1
//
//  Created by 杨东举 on 2022/1/22.
//

import SwiftUI


func initConData()->ConTips {
    var output:[Conventional]=[]
    var finish:Int=0
    var tol:Int=1
    
    if let dataStored = UserDefaults.standard.object(forKey: "ConList0124X") as? Data {
        do {
            let data = try decoder.decode([Conventional].self, from: dataStored)
            for item in data {
                if !item.deleted {
                    let remainDays = calculateRemainDays(startDate: item.time, nowDate: Date.now)
                    let time:Date = abs(remainDays)==0 ? Date.now : item.time
                    let isPassed:Bool = remainDays <= 0 ? true : false
                    output.append(Conventional(id: output.count, name: item.name, remainDays: remainDays, initTime: item.initTime, time: time, lunarDp: item.lunarDp, isPassed: isPassed, deleted: item.deleted))
                    if(isPassed==true){
                        finish += 1
                    }
                }
            }
        } catch {
            print("Failed to decode data: \(error)")
        }
    }
    tol = (output.count==0 ? 1:output.count)
    print("Conventional=",output)
    return ConTips(data: output, finished: finish, tolcount: tol)
}

struct TipsConventionalView: View {
    @Binding var backColor:Color
    @Binding var showContent: Bool
    @State var showAdd = false
    @State var tolMatters:Int=0
    
//        @ObservedObject var ConData :ConTips = ConTips(dp: 1)
    @EnvironmentObject var ConData :ConTips
    
    
    var body: some View {
        ZStack {
            
//            backColor
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(spacing:-20) {
                    HStack() {
                        Text("总有一些日子值得记忆")
                            .font(.system(size: 20, weight: .bold))
                        //                        .fontWeight(20)
                        Spacer()
                        Image(systemName: "xmark")
                            .frame(width:36,height:36)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.showContent=false
                            }
                    }
                    .padding()
                    HStack {
                        if self.ConData.ConList.count==0{
                            Text("\(0)")
                                .font(.system(size: 58, weight: .bold))
                                .frame(width: 60, height: 60)
                        }
                        else{
                            Text("\(self.ConData.tol)")
                                .font(.system(size: 58, weight: .bold))
                                .frame(width: 60, height: 60)
                        }
                        Text("Days")
                            .font(.system(size: 18, weight: .bold))
                            .offset(y:8)
                            .padding(.leading,-0)
                        Spacer()
                        Button(action: {self.showAdd.toggle()}){
                            Image(systemName: "plus")
                                .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                .padding(.leading,10)
                                .offset(y:8)
                        }
                        .sheet(isPresented: $showAdd){
                            TipsConEditView(backColor: $backColor)
                                .environmentObject(self.ConData)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                ScrollView(.vertical,showsIndicators: false) {
                    VStack {
                        ForEach(self.ConData.ConList) { item in
                            if !item.deleted{
                                ConventionalCardView(index: item.id, backColor: $backColor)
                                    .environmentObject(self.ConData)
                                    .padding()
                                    .padding(.top,50)
                                    .frame(width: screen.width, height: 150)
                            }
                        }
                    }
                }
                .frame(width: screen.width)
                .offset(y:-20)
                //                .padding(.top,30)
            }
            .padding(.top,40)
            .offset(x:0,y:16)
            
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct TipsConventionalView_Previews: PreviewProvider {
    static var previews: some View {
        TipsConventionalView(backColor: .constant(.white), showContent: .constant(false))
            .environmentObject(ConTips())
    }
}

struct ConventionalCardView: View {
    @EnvironmentObject var ConDate:ConTips
    var index:Int
    
    @Binding var backColor:Color
    @State var showEdit = false
    
    var body: some View {
        ZStack {
            Button(action:{
                self.showEdit=true
            }){
                VStack(alignment: .leading, spacing: 0){
                    HStack {
                        Text("\(ConDate.ConList[index].name)")
                            .font(.custom("", size: 29))
                        Spacer()
                        Button(action:{
                            self.ConDate.conDelete(id: self.index)
                        }){
                            Image(systemName:"trash")
                                .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                .offset(x:10)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        if self.ConDate.ConList.count > index, self.ConDate.ConList[index].lunarDp==false{
                            Text("\(gregorian_to_CN(date:ConDate.ConList[index].initTime))")
                                .font(.custom("", size: 15))
                            .padding(.leading)
                        }
                        else{
                            Text("\(gregorian_to_lunar(date:ConDate.ConList[index].initTime))")
                                .font(.custom("", size: 15))
                                .padding(.leading)
                        }
                        Spacer()
                        Text("\(ConDate.ConList[index].remainDays)")
                            .font(.custom("Rosther", size: 35))
                        Text("Days")
                            .font(.custom("Rosther", size: 23))
                            .font(.system(size: 18, weight: .bold))
                            .offset(y:8)
                            .padding(.trailing,10)
                    }
                    
                    Spacer()
                    
                }
            }
            .foregroundColor(.black)
            .sheet(isPresented: self.$showEdit, content: {
                if self.ConDate.ConList.count > index {
                    TipsConEditView(time: self.ConDate.ConList[index].initTime, isHidden:self.ConDate.ConList[index].lunarDp, backColor: $backColor, title: self.ConDate.ConList[index].name, id: self.ConDate.ConList[index].id)
                        .environmentObject(self.ConDate)
                }
            })
        }
        .frame(width:screen.width-20,height:150)
        .background(Color(#colorLiteral(red: 1, green: 0.5249271989, blue: 0.4519428015, alpha: 1)))
        .cornerRadius(10)
        .shadow(color:Color.black.opacity(10),radius: 3,x:0,y: 1)
    }
}
