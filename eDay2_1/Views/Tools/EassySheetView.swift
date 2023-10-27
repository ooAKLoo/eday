//
//  EassySheetView.swift
//  eDay5
//
//  Created by 杨东举 on 2022/1/12.
//

import SwiftUI

struct EassySheetView: View {
    
    @EnvironmentObject var eassyData:Eassy
    @Environment(\.presentationMode) var presentation
    
    @State var title:String=""
    @State var text:String=""
    
    var id:Int?=nil
    
    var body: some View {
        ZStack {
            VStack{
                Form{
                    Section{
                            HStack {
                                Image(systemName: "textformat.size")
                                TextField(NSLocalizedString("EassySheetView.文本名称", comment: "Text Name"), text: self.$title)

                            }
                        VStack {
                            HStack {
                                    Image(systemName: "doc.plaintext")
                                Text(NSLocalizedString("EassySheetView.文本内容", comment: "Text Content"))

                                    Spacer()
                            }
                        
                            TextEditor(text: self.$text)
                                .frame( height: 400)
                                
                        }
                    }
                    Section{
                        Button(action:{
                            if self.id==nil{
                                self.eassyData.add(data: SingleEassy(id: 0, title: title, text: text, date: Date.now, isDeleted: false))
                            }
                            else{
                                self.eassyData.edit(index: self.id!, data: SingleEassy(id: 0, title: title, text: text, date: Date.now, isDeleted: false))
                            }
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("EassySheetView.确认", comment: "Confirm"))
                                .foregroundColor(.black)
                                .foregroundColor(.black)
                        }
                        Button(action:{
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("EassySheetView.取消", comment: "Cancel"))
                                .foregroundColor(.black)
                        }
                    }
                }
                    
                
            }
           
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct EassySheetView_Previews: PreviewProvider {
    static var previews: some View {
        EassySheetView()
    }
}
