//
//  ToolsSecurityImageView.swift
//  eDay6
//
//  Created by 杨东举 on 2022/1/10.
//
 import SwiftUI
 struct ToolsSecurityImageView: View {
    @State var backColor:Color = .white
    @Binding var showImage:Bool
     @State var selectImage = false
    @State var openCameraRoll = false
    @State var imageSelected:UIImage=UIImage()
    @State var imageSelectedData : Data = .init(count: 0)
    @State var imageSelectedList:[Data]=[]
    @State var selectedLayout:LayoutType = .single
    
    @State var adddp = false
    
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(entity:ImageData.entity(),sortDescriptors:[
//        NSSortDescriptor(keyPath:\ImageData.image,ascending:true),
//        NSSortDescriptor(keyPath:\ImageData.id,ascending:true),
//    ])
    @FetchRequest(sortDescriptors:[])
    private var imageList:FetchedResults<ImageData>
    
    @State var displaySingleImage:Bool=false
    
    @State var transImage:UIImage=UIImage()
     var body: some View {
        ZStack {
            backColor
            VStack{
                VStack {
                    HStack(spacing:280) {
                
                        Image(systemName: "plus")
                            .frame(width: 36,height:36)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.selectImage=true
                                self.openCameraRoll=true
                            }
                        Button(action:{
                            self.showImage=false
                            if self.imageSelectedData.count != 0{
                                add()
                            }
                        }){
                        Image(systemName: "xmark")
                            .frame(width:36,height:36)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                        }
                        
                        
                    }
                
                    Picker("Layout",selection: $selectedLayout){
                        ForEach(LayoutType.allCases,id:\.self){type in
                            switch type{
                            case .single:
                                Image(systemName: "list.bullet")
                            case .double:
                                Image(systemName: "square.grid.2x2")
                            case .adaptive:
                                Image(systemName: "square.grid.3x3")
                            }
                            
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                }
                .padding(.top,80)
                .frame(width: screen.width, height: screen.height/5)
                .background(Color(#colorLiteral(red: 0.9113450646, green: 0.966155827, blue: 0.9853895307, alpha: 1)))
                
                
                VStack {
//                    HStack{
//                        Text("\(imageList.count)")
//                    }
                    
                    if showImage{
                    ScrollView() {
                        LazyVGrid(columns: selectedLayout.columns, spacing: 1){
                             ForEach(imageList , id:\.self) { item in
                                switch (selectedLayout){
                                case .single:
                                    HStack {
                                        ImageSingleView(image:  UIImage(data: item.image ?? imageSelectedData) ?? UIImage(imageLiteralResourceName: "Card1"))
//                                        ImageSingleView(image: UIImage(imageLiteralResourceName: "Card1"))
                                        Spacer()
                                        Image(systemName:"trash")
                                            .foregroundColor(Color(#colorLiteral(red: 0.4222230911, green: 0.5350257158, blue: 0.9202566743, alpha: 0.8470588235)))
                                            .frame(width: 44, height: 44)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 26,style: .continuous))
                                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                                            .padding(.leading,10)
                                            .onTapGesture {
                                                delete(image: item)
                                        }
                                        
                                    }
                                    .frame(width: screen.width-10, height: 55)
                                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                                    .padding(.vertical,4)
                                    .padding(.horizontal,16)
                                default:
                                    Image(uiImage:  UIImage(data: item.image ?? imageSelectedData) ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode:.fit)
                                        .onTapGesture {
                                            self.displaySingleImage=true
                                            self.transImage=UIImage(data:item.image!)!
                                        }
                                }
                            }
                        
                            
                            ForEach(imageSelectedList , id:\.self) { item in
                                switch (selectedLayout){
                                case .single:
                                    HStack {
                                        ImageSingleView(image:  UIImage(data: item)!)
                                        Spacer()
                                        
                                    }
                                    .padding(.vertical,4)
                                    .padding(.horizontal,16)
                                default:
                                    Image(uiImage:  UIImage(data: item)!)
                                        .resizable()
                                        .aspectRatio(contentMode:.fit)
                                        .onTapGesture {
                                            self.displaySingleImage=true
                                            self.transImage=UIImage(data:item)!
                                        }
                                }
                            }
                        }
                    }
//                    .animation(.default)
                    }
                    
                 }
                .frame(width: screen.width, height: screen.height/8*7)
            }
            if displaySingleImage{
                Color.black.edgesIgnoringSafeArea(.all)
                DisplayImage(displayImage: $displaySingleImage, image: $transImage)
            }
           
        }
        .sheet(isPresented:$openCameraRoll){
            ImagePicker(selectedImage: $imageSelected, selectedImageData: $imageSelectedData, selectedImageList: $imageSelectedList, sourceType: .photoLibrary)
        }
        .edgesIgnoringSafeArea(.all)
    }
    private func delete(image:ImageData){
        withAnimation{
            moc.delete(image)
//            for x in imageList{
//                moc.delete(x)
//            }
        }
        try!self.moc.save()
    }
    private func save(){
        do{
            try moc.save()
        }catch{
            let error = error as NSError
            fatalError("未解析的错误:\(error)")
        }
    }
    
    func add(){
          print("list=",imageSelectedList.count)
        print("coredata:",imageList.count)
//        let add=ImageData(context: self.moc)
        if imageSelectedList.count != 0{
                for image in imageSelectedList{
                    let add=ImageData(context: self.moc)
                    add.image=image
                    save()
                    print("添加+1")
                }
        }
     }
}
 struct ToolsSecurityImageView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsSecurityImageView(showImage: .constant(false))
    }
}
 struct SecurityImageTopView: View {
    @Binding var showImage:Bool
    @Binding var selectImage:Bool
    @Binding var openCameraRoll:Bool
    
    @Binding var adddp:Bool
    
    @Binding var selectedLayout:LayoutType
    var body: some View {
        VStack {
            HStack(spacing:280) {
        
                Image(systemName: "plus")
                    .frame(width: 36,height:36)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
                    .onTapGesture {
                        self.selectImage=true
                        self.openCameraRoll=true
                    }
    
                
                Image(systemName: "xmark")
                    .frame(width:36,height:36)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
                    .onTapGesture{
                        self.showImage=false
                        self.adddp=true
                    }
                
                
            }
        
            Picker("Layout",selection: $selectedLayout){
                ForEach(LayoutType.allCases,id:\.self){type in
                    switch type{
                    case .single:
                        Image(systemName: "list.bullet")
                    case .double:
                        Image(systemName: "square.grid.2x2")
                    case .adaptive:
                        Image(systemName: "square.grid.3x3")
                    }
                    
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
        }
        .padding(.top,80)
        .frame(width: screen.width, height: screen.height/5)
        .background(Color(#colorLiteral(red: 0.9113450646, green: 0.966155827, blue: 0.9853895307, alpha: 1)))
    }
    
}
 
