//
//  ToolsView.swift
//  EditText
//
//  Created by 杨东举 on 2022/1/10.
//

import SwiftUI

struct ToolsView: View {
    @Binding var backColor:Color
    @Binding var showContent: Bool
    @State var showAdd = false
    
    @State var screen:CGRect = UIScreen.main.bounds;
    @State var showScannerSheet = false
    @State var texts:[ScanData]=[]
    @State var scanText:String=""
    var body: some View {
        ZStack{
            backColor
            VStack {
                ToolsTopView(backColor: $backColor, showContent: $showContent, showAdd: $showAdd, showScannerSheet: $showScannerSheet, texts: $texts, scanText: $scanText)
                
                if showContent{
                    ScanEditorView(screen: $screen, texts: $texts, scanText: $scanText)
                }
                
            }
            .padding(.top,40)
            .offset(x:0,y:16)
            .frame(width: screen.width)//在每个Card的主页面设置宽度，否则页面返回时会造成抖动
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView(backColor: .constant(.purple), showContent: .constant(false))
    }
}

struct ToolsTopView: View {
    @Binding var backColor:Color
    @Binding var showContent: Bool
    @Binding var showAdd:Bool
    @Binding var showScannerSheet:Bool
    
    @Binding var texts:[ScanData]
    @Binding var scanText:String
    
    var body: some View {
        HStack(spacing:120) {
            Button(action:{
                self.showScannerSheet=true
                self.texts=[]
            }){
                Image(systemName: "camera")
                    .frame(width: 36,height:36)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
                
            }
            .sheet(isPresented:$showScannerSheet){
                self.makeScannerView()
            }
            Button(action: {self.showAdd.toggle()}){
                Image(systemName: "photo.on.rectangle.angled")
                    .frame(width: 36,height:36)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
            }
            
            Image(systemName: "xmark")
                .frame(width:36,height:36)
                .foregroundColor(.white)
                .background(Color.black)
                .clipShape(Circle())
                .onTapGesture {
                    self.showContent=false
                }
        }
        Spacer()
    }
    private func makeScannerView()->ScannerView{
        ScannerView(completion: {
            textperPage in
            if let outputText = textperPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                let newScanDate = ScanData(content: outputText)
                self.texts.append(newScanDate)
                scanText=stringStr(scanData: texts)
                //                printScanData(text: texts[0].content)
            }
            self.showScannerSheet = false
        })
    }
}

struct ScanEditorView: View {
    @Binding var screen:CGRect
    @Binding var texts:[ScanData]
    @Binding var scanText:String
    var body: some View {
        ZStack{
            TextEditor(text: $scanText)
            //                    .frame(height: 350)
            //                    .border(Color.blue)
                .padding()
                .padding(.top,5)
            
            if texts.isEmpty {
                Text("No scan words")
                    .foregroundColor(Color(UIColor.placeholderText))
            }
            
        }
        .frame(width:screen.width-20,height:screen.height-150)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color:Color.black.opacity(0.2),radius: 20,x:0,y:20)
        .padding(.horizontal,30)
    }
    
}
