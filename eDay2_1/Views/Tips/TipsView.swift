//
//  TipsView.swift
//  eDay
//
//  Created by 杨东举 on 2022/1/7.
//
 import SwiftUI
 func initMedData()->(Int,Int,[Medication]){
    var output:[Medication]=[]
    var finish:Int=0
    var tol:Int=1
     if let dataStored =  UserDefaults.standard.object(forKey: "MedListX0124") as? Data{
        let data=try! decoder.decode([Medication].self, from: dataStored)
        for item in data{
            if !item.deleted{
             
                output.append(Medication(id:output.count, name: item.name, time: item.time, dp1:item.dp1, dp2:item.dp2, dp3:item.dp3, dp4:item.dp4,frequ: item.frequ, isChecked: item.isChecked, deleted: item.deleted, timeNum: item.timeNum))
                if(item.isChecked==true){
                    finish+=1
                }
            }
        }
    }
    tol=(output.count==0 ? 1:output.count)
//    print("out=",output)
    return (finish,tol,output)
}

struct TipsView: View {
    @Binding var backColor:Color
    @Binding var showContent: Bool
    @State var showAdd = false
    @State var showOptions = false
    
    
    @State var showScannerSheet = false
    @State var texts:[ScanData]=[]
     
    
    @ObservedObject var MedData :MedTips = MedTips(data: initMedData().2,finished: initMedData().0,tolcount: initMedData().1)
    
    func fetchDataFromServer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let jsonData = """
            {
                "id": 0,
                "name": "测试药物",
                "remain": 4,
                "time": ["2023-07-29T12:00:00+00:00", "2023-07-29T14:00:00+00:00", "2023-07-29T16:00:00+00:00", "2023-07-29T18:00:00+00:00"],
                "dp1": 1,
                "dp2": 1,
                "dp3": 1,
                "dp4": 1,
                "frequ": 0,
                "isChecked": false,
                "deleted": false,
                "timeNum": 4
            }
            """.data(using: .utf8)!

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let medication = try decoder.decode(Medication.self, from: jsonData)
                self.MedData.add(data: medication) // 添加这一行
                print(medication)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }


    
    
    var body: some View {
           ZStack {
               backColor
               
               VStack {
                   
                   HStack {
                       VStack {
                           Button(action: {
                               self.showOptions.toggle()
                           }) {
                               Image(systemName: "plus")
                                   .frame(width: 36,height:36)
                                   .foregroundColor(.white)
                                   .background(Color.black)
                                   .clipShape(Circle())
                           }
                           .sheet(isPresented: $showAdd){
                               MedTipsEditView(backColor: $backColor)
                                   .environmentObject(self.MedData)
                           }
                       }
                       .padding(.top,50)
                       .padding(.leading,30)

                       if self.showOptions {
                           HStack {
                               Button(action:{
                                   self.showScannerSheet = true
                                   self.showOptions = false
                               }) {
                                   Image(systemName: "camera")
                                       .frame(width: 36,height:36)
                                       .foregroundColor(.white)
                                       .background(Color.black)
                                       .clipShape(Circle())
                               }
                               .sheet(isPresented:$showScannerSheet){
                                   self.makeScannerView()
                               }
                               Button(action:{
                                   self.showAdd = true
                                   self.showOptions = false
                               }) {
                                   Image(systemName: "pencil")
                                       .frame(width: 36,height:36)
                                       .foregroundColor(.white)
                                       .background(Color.black)
                                       .clipShape(Circle())
                               }
                               Button(action: fetchDataFromServer){
                                   Image(systemName: "mic.fill")
                                       .frame(width: 36,height:36)
                                       .foregroundColor(.white)
                                       .background(Color.black)
                                       .clipShape(Circle())
                               }

                           }
                           .transition(.move(edge: .leading))  //Add transition effect
                           .padding(.top,50)
//                           .padding(.leading,30)
                       }
                       
                       Spacer()

                       VStack {
                           Button(action: {
                               self.showContent = false
                               self.showOptions = false
                           }) {
                               Image(systemName: "xmark")
                                   .frame(width:36,height:36)
                                   .foregroundColor(.white)
                                   .background(Color.black)
                                   .clipShape(Circle())
                           }
                       }
                       .padding(.top,50)
                       .padding(.trailing,30)
                   }

                   
                   ScrollView(.vertical,showsIndicators: false) {
                       VStack {
                           ForEach(self.MedData.MedList) { item in
                               if !item.deleted{
                                   MedCardView(index: item.id, backColor: $backColor)
                                       .environmentObject(self.MedData)
                                       .padding()
                               }
                           }
                       }
                   }
                   .frame(width: screen.width)
               }

           }
           .edgesIgnoringSafeArea(.all)
       }
    private func makeScannerView()->ScannerView{
        ScannerView(completion: {
            textperPage in
            if let outputText = textperPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanDate = ScanData(content: outputText)
                self.texts.append(newScanDate)
                printScanData(text: texts[0].content)
            }
            self.showScannerSheet = false
        })
    }
}
 struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView(backColor: .constant(.purple),showContent: .constant(false))
        
    }
}
  struct MedCardView: View {
    
     @EnvironmentObject var MedDate:MedTips
    var index:Int
    
    
    @Binding var backColor:Color
    @State var showEdit = false
    
    var body: some View {
        HStack {
            Button(action:{
                self.MedDate.medDelete(id: self.index)
            })
            {
            Image(systemName:"trash")
                .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                .frame(width: 44, height: 44)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                .padding(.leading,10)
            
            }
            Button(action:{
                self.showEdit = true
            })
            {
                    Group {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "pills.fill")
                                .foregroundColor(backColor)
                            Text("药品名称:")
                                .font(.headline)
                               .fontWeight(.heavy)
                               .foregroundColor(.black)
                            Text("\(self.MedDate.MedList[index].name)")
                            Spacer()
                        }.padding(.top,-20)
                        
                        HStack( spacing: 15) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(backColor)
                                .offset(y:-5)
                            Text("时间:")
                                .font(.headline)
                               .fontWeight(.heavy)
                               .foregroundColor(.black)
                               .offset(y:-5)
//                            Spacer()
                               
                            
                            
                            
                            VStack{
                                HStack(spacing:10){
                                    if(self.MedDate.MedList[index].dp1==1){
                                        Text("\(modiferDateToStr(time:self.MedDate.MedList[index].time[0]))")
                                            .foregroundColor(.black)
                                              .frame(width: 54, height: 24)
                                  .background(Color.white)
                                  .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                 .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                }
                                    else{
                                        Text("----")
                                       .foregroundColor(.black)
                                                  .frame(width: 54, height: 24)
                                      .background(Color.white)
                                      .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                    }
                                    
                                    
                                    if(self.MedDate.MedList[index].dp2==1){
                                    Text("\(modiferDateToStr(time: self.MedDate.MedList[index].time[1]))")
                                            .foregroundColor(.black)
                                              .frame(width: 54, height: 24)
                                  .background(Color.white)
                                  .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                 .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                }
                                    else{
                                        Text("----")
                                       .foregroundColor(.black)
                                                  .frame(width: 54, height: 24)
                                      .background(Color.white)
                                      .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                    }
                                    
                                }
                                .offset(y:-7)
                                
                                HStack(spacing:10){
                                    if(self.MedDate.MedList[index].dp3==1){
                                    Text("\(modiferDateToStr(time: self.MedDate.MedList[index].time[2]))")
                                            .foregroundColor(.black)
                                              .frame(width: 54, height: 24)
                                  .background(Color.white)
                                  .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                 .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                }
                                    else{
                                        Text("----")
                                       .foregroundColor(.black)
                                                  .frame(width: 54, height: 24)
                                      .background(Color.white)
                                      .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                    }
                                    
                                    
                                    if(self.MedDate.MedList[index].dp4==1){
                                    Text("\(modiferDateToStr(time: self.MedDate.MedList[index].time[3]))")
                                            .foregroundColor(.black)
                                              .frame(width: 54, height: 24)
                                  .background(Color.white)
                                  .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                 .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                }
                                    else{
                                        Text("----")
                                       .foregroundColor(.black)
                                                  .frame(width: 54, height: 24)
                                      .background(Color.white)
                                      .clipShape(RoundedRectangle(cornerRadius: 6,style: .continuous))
                                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                    }
                                    
                                }
                                .offset(y:-12)
                            }
                            .offset(y:18)
                             
                        }
                    }
                    .padding(.leading,-1)
                    .padding(.top)
                 }
                    .padding(.leading,18)
            }
            .foregroundColor(.black)
            .sheet(isPresented: self.$showEdit, content: {
                MedTipsEditView(time1: self.MedDate.MedList[index].time[0], time2: self.MedDate.MedList[index].time[1], time3: self.MedDate.MedList[index].time[2], time4: self.MedDate.MedList[index].time[3], timeIndex:self.MedDate.MedList[index].timeNum, selectedFreque:self.MedDate.MedList[index].frequ, backColor: $backColor, title: self.MedDate.MedList[index].name,id: self.MedDate.MedList[index].id)
                    .environmentObject(self.MedDate)
            })
            
            
            Image(systemName:self.MedDate.MedList[index].isChecked ? "checkmark.square.fill" :"square")
                .imageScale(.large)
                .offset(x:-0,y:0)
                .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                .frame(width:44, height: 44)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                .padding(.trailing,10)
                .padding(.bottom,1)
                .onTapGesture {
                    self.MedDate.finish(id: self.index)
                }
            
        }
        .frame(width:screen.width-15,height:105)
        .background(.white)
        .cornerRadius(80)
        .shadow(color:Color.black.opacity(0.1),radius: 1,x:0,y: 1)
        .padding(5)
    }
}
  
