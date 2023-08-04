//
//  DisplayImage.swift
//  eDay6
//
//  Created by 杨东举 on 2022/1/12.
//

import SwiftUI

struct DisplayImage: View {
    
    @Binding var displayImage:Bool
    @Binding var image:UIImage
    @State var offset: CGSize = .zero
    var body: some View {
        
        let dragGesture=DragGesture()
            .onChanged{ value in
                self.offset = value.translation
                changeShow()
            }
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            .offset(y:offset.height-30)
            .gesture(dragGesture)
      
        }
        .statusBar(hidden: true)
    }
    private func changeShow(){
        if offset.height>100{
            self.displayImage=false
                    }
    }
}

struct DisplayImage_Previews: PreviewProvider {
    static var previews: some View {
        DisplayImage(displayImage: .constant(false), image: .constant(UIImage(imageLiteralResourceName: "me")))
    }
}
