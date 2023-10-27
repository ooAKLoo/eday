//
//  Scandata.swift
//  Sacn
//
//.
//

import SwiftUI
import Foundation

func printScanData(text:String){
    print("text=",text)
}

func stringStr(scanData:[ScanData])->String{
    var str:String=""
    for i in scanData{
        str+=i.content
    }
    return str
}


struct ScanData:Identifiable{
    var id=UUID()
    let content:String
    init(content:String){
        self.content=content
    }
    
}
