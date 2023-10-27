//
//  TipsConEditView.swift
//  eDay2_1
//
//.
//

import Foundation


//
//  TipsEditView.swift
//  eDay
//
//.
//

import SwiftUI


struct TipsConEditView: View {
    
    @EnvironmentObject var ConData :ConTips
    @Environment(\.presentationMode) var presentation
    
    
    @State var time:Date=Date()
    
    @State var isHidden:Bool=false
    
    
    
    @Binding var backColor:Color
    @State var title:String=""
    
    
    
    var id:Int?=nil
    
    
    
    var body: some View {
        
        VStack {
            NavigationView{
                Form{
                    Section{
                        HStack {
                            Image(systemName: "rectangle.and.paperclip")
                                .foregroundColor(self.backColor)
                            TextField(NSLocalizedString("eventNamePlaceholder", comment: ""), text: self.$title)
                        }
                        
                        VStack (alignment: .leading, spacing: 0){
                            HStack {
                                Image(systemName: "person.badge.clock")
                                    .foregroundColor(self.backColor)
                                Text(NSLocalizedString("dateTitle", comment: ""))
                                Spacer()
                                ConToggleView(backColor: $backColor, isHidden: $isHidden)
                                
                            }
                            TipsConDatePicker(selection: $time , minuteInterval: 1, displayedComponents:  [.hourAndMinute, .date], lunarDp: $isHidden)
                                .padding(.trailing,110)
                        }.frame(height: 100)
                    }
                    
                    Section{
                        Button(action:{
                            if self.id == nil{
                                self.ConData.add(data: Conventional(id: 0, name: title, remainDays: 0, initTime: time, time: time, lunarDp: isHidden, isPassed: false, deleted: false))
                            }
                            else{
                                self.ConData.edit(id: self.id!, data: Conventional(id:self.id!, name: title, remainDays: 0, initTime: time, time: time, lunarDp: isHidden, isPassed: false, deleted: false))
                            }
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("confirmButton", comment: ""))
                                .foregroundColor(.black)
                            
                        }
                        Button(action:{
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("cancelButton", comment: ""))
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

struct TipsConEditView_Previews: PreviewProvider {
    static var previews: some View {
        TipsConEditView(backColor: .constant(Color(#colorLiteral(red: 0.9771289229, green: 0.50649333, blue: 0.2435890436, alpha: 1))))
    }
}

struct ConToggleView: View {
    @Binding var backColor:Color
    @Binding var isHidden:Bool
    var body: some View {
        ZStack{
            Capsule()
                .fill(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                .frame(width: 100, height: 30)
            HStack {
                
                if isHidden{
                    Spacer()
                    Text(NSLocalizedString("lunar", comment: "Lunar Calendar"))
.foregroundColor(Color(#colorLiteral(red: 0.4568658471, green: 0.8275114298, blue: 0.9175289273, alpha: 1)))
                    
                }
                ZStack{
                    
                    Capsule()
                        .frame(width: 40, height: 40)
                        .foregroundColor(backColor)
                    Image(systemName:isHidden ? "poweron" : "minus")
                        .foregroundColor(Color(#colorLiteral(red: 0.4568658471, green: 0.8275114298, blue: 0.9175289273, alpha: 1)))
                        .animation(.spring(response: 0.25, dampingFraction: 1, blendDuration: 0))
                }.onTapGesture {
                    self.isHidden.toggle()
                }
                if !isHidden{
                    Text(NSLocalizedString("gregorian", comment: "Gregorian Calendar"))

                        .foregroundColor(Color(#colorLiteral(red: 0.4568658471, green: 0.8275114298, blue: 0.9175289273, alpha: 1)))
                    Spacer()
                }
                
            }.frame(width: 100, height: 30)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
            
        }
    }
}
