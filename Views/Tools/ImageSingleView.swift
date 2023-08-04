//
//  ImageSingleView.swift
//  eDay6
//
//  Created by 杨东举 on 2022/1/11.
//

import SwiftUI

struct ImageSingleView: View {
    let image:UIImage
    var body: some View {
//        HStack(spacing:16){
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Spacer()
//        }
//        .padding(.vertical,4)
//        .padding(.horizontal,16)
    }
}

struct ImageSingleView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSingleView(image: UIImage(imageLiteralResourceName: "Card1"))
    }
}
