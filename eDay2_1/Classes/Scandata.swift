//
//  Scandata.swift
//  Sacn
//
//.
//

import SwiftUI
import Foundation

/// Prints the provided scan data text to the console with a prefix.
func printScanData(text:String){
    print("text=",text)
}

/// Concatenates the content of the provided list of `ScanData` into a single string.
func stringStr(scanData:[ScanData])->String{
    var str:String=""
    for i in scanData{
        str+=i.content
    }
    return str
}

/// Represents a single piece of scanned data.
struct ScanData:Identifiable{
    var id=UUID()
    let content:String
    init(content:String){
        self.content=content
    }
    
}
