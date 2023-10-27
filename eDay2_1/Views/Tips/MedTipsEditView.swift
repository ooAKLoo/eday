//
//  TipsEditView.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/7.
//

import SwiftUI


struct MedTipsEditView: View {
    
    @EnvironmentObject var MedData :MedTips
    @Environment(\.presentationMode) var presentation
    
    
    @State var time1:Date=Date()
    @State var time2:Date=Date()
    @State var time3:Date=Date()
    @State var time4:Date=Date()
    
    @State var times:[Date]=[]
    
    @State var timeShow:[Int]=[0,0,0,0]
    @State var timeIndex:Int=0
    @State var timeLimit:Bool=false
    @State var isHidden:Bool=false
    
    private let frequs = [
        (NSLocalizedString("everyDay", comment: "Every day"), "circle.grid.cross.fill"),
        (NSLocalizedString("everyWeek", comment: "Every week"), "circle.grid.cross.up.fill"),
        (NSLocalizedString("everyOtherDay", comment: "Every other day"), "circle.grid.cross.down.fill"),
    ]
    
    @State  var selectedFreque:Int = 0
    
    //    @State  var minuteInterval = 10
    
    @Binding var backColor:Color
    @State var title:String=""
    
    
    
    var id:Int?=nil
    
    
    
    var body: some View {
        
        VStack {
            NavigationView{
                Form{
                    Section{
                        HStack {
                            Image(systemName: "cross.case")
                                .foregroundColor(self.backColor)
                            TextField(NSLocalizedString("medicineName", comment: "Medicine Name Placeholder"), text: self.$title)

                        }
                        VStack {
                            HStack {
                                Image(systemName: "alarm")
                                    .foregroundColor(self.backColor)
                                //                                Spacer()
                                Text(NSLocalizedString("reminderTime", comment: "Reminder Time"))

                                Spacer()
                                Button(action:{
                                    if !timeLimit{
                                        self.timeShow[timeIndex%4]=1
                                        timeIndex+=1
                                        if timeIndex==4{
                                            timeLimit=true
                                        }
                                    }
                                    else{
                                        timeIndex-=1
                                        self.timeShow[timeIndex%4]=0
                                        if timeIndex==0{
                                            timeLimit=false
                                        }
                                    }
                                   
                                }){
                                    Image(systemName:timeLimit ? "minus":"plus")
                                        .frame(width: 10, height: 10)
                                }.foregroundColor(backColor)
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            
                            Spacer()
                            HStack(spacing:-10) {
                                if timeShow[0] == 1 || (self.id != nil && self.timeIndex>=1){
                                    MyDatePicker(selection: $time1 , minuteInterval: 1, displayedComponents: .hourAndMinute)
//                                        .hidden()
                                }
                                else{
                                    HStack{
                                        
                                    }.frame(width: 50, height: 20)
//                                        .border(.black)
                                        .padding()
                                }
                                if timeShow[1] == 1 || (self.id != nil && self.timeIndex>=2){
                                    MyDatePicker(selection: $time2, minuteInterval: 1, displayedComponents: .hourAndMinute)
                                }
                                else{
                                    HStack{
                                        
                                    }.frame(width: 50, height: 20)
//                                        .border(.black)
                                        .padding()
                                }
                                if timeShow[2] == 1 || (self.id != nil && self.timeIndex>=3){
                                    MyDatePicker(selection: $time3, minuteInterval: 1, displayedComponents: .hourAndMinute)
                                }
                                else{
                                    HStack{
                                        
                                    }.frame(width: 50, height: 20)
//                                        .border(.black)
                                        .padding()
                                }
                                if timeShow[3] == 1 || (self.id != nil && self.timeIndex==4){
                                    MyDatePicker(selection: $time4, minuteInterval: 1, displayedComponents: .hourAndMinute)
                                }
                                else{
                                    HStack{
                                        
                                    }.frame(width: 50, height: 20)
//                                        .border(.black)
                                        .padding()
                                }
                            }
                            .frame(height:50)
                        }
                     
                        
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(self.backColor)
                            Picker(selection: $selectedFreque, label: Text(NSLocalizedString("frequency", comment: "Frequency Picker"))) {

                                ForEach(0 ..< frequs.count) {
                                    Label(frequs[$0].0, systemImage: frequs[$0].1)
                                        .foregroundColor(.black)
                                }
                            }
                            
                        }
                    }
                    Section{
                        Button(action:{
                            times.append(time1)
                            times.append(time2)
                            times.append(time3)
                            times.append(time4)
                            if self.id == nil{
                                self.MedData.add(data: Medication(id: 0, name: self.title,  time: self.times,dp1:1,dp2:1,dp3:1,dp4:1, frequ: self.selectedFreque, isChecked: false, deleted: false, timeNum: timeIndex))
                            }
                            else{
                                self.MedData.edit(id: self.id!, data: Medication(id: self.id!, name: self.title, time: self.times,dp1:1,dp2:1,dp3:1,dp4:1, frequ: self.selectedFreque, isChecked: false, deleted: false, timeNum: timeIndex))
                            }
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("confirm", comment: "Confirm Button"))
                                    .foregroundColor(.black)
                            
                        }
                        Button(action:{
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("cancel", comment: "Cancel Button"))
                                    .foregroundColor(.black)
                        }
                        
                        
                    }
                }
                .navigationTitle(NSLocalizedString("addTitle", comment: ""))
            }
            Spacer()
        }
    }
}


struct MedTipsEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedTipsEditView(backColor: .constant(.black))
    }
}
