//
//  Time.swift
//  eDay
//
//.
//
import UIKit
import SwiftUI

class Time:ObservableObject{
//    @Published var day:CGFloat
   @Published var hour:CGFloat
    let dateformatter = DateFormatter()
    var time:Date = Date(timeInterval: 20, since: Date())
    
    init() {
        self.dateformatter.dateFormat = "HH"
        self.hour=CGFloat(Float(dateformatter.string(from:self.time)) ?? 0)
//        self.dateformatter.dateFormat = "dd"
//        self.day=CGFloat(Float(dateformatter.string(from:self.time)) ?? 0)
    }
    public func update(){
        self.time=Date()
        self.hour=CGFloat(Float(dateformatter.string(from:self.time)) ?? 0)
    }
}

func gregorian_to_lunar(date:Date) ->String{
    let chinese = Calendar(identifier: .chinese)

           let formatter = DateFormatter()

           formatter.locale = Locale(identifier: "en_US")

           formatter.calendar = chinese

           //日期样式

           formatter.dateStyle = .full

           


           let lunar = formatter.string(from: date)

    return lunar  //公历日期： 2021辛丑年腊月廿二星期一

}

//formatter.locale = Locale(identifier: "zh_CN")

func gregorian_to_CN(date:Date) ->String{
    
//    print(date)

           let formatter = DateFormatter()

           formatter.locale = Locale(identifier: "en_US")

//           formatter.calendar = chinese

           //日期样式

           formatter.dateStyle = .full

           


           let lunar = formatter.string(from: date)

    return lunar  //公历日期： 2021辛丑年腊月廿二星期一

}

func calculateRemainDays(startDate:Date,nowDate:Date)->Int{
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = "yyyy-MM-dd"

    // 开始日期
    let startDate = formatter.date(from: modiferDateToStr_date_YMD(time: startDate))

    // 结束日期
    let endDate = formatter.date(from: modiferDateToStr_date_YMD(time: nowDate))
    let diff:DateComponents = calendar.dateComponents([.day], from: startDate!, to: endDate!)
    let remainDays:Int = -diff.day!
    
    var yearDays:Int=365
    if modiferDateToStr_date_MD(time: startDate!) != modiferDateToStr_date_MD(time: nowDate) && abs(remainDays)==365{
        yearDays=366
    }
    return remainDays%yearDays
}

func modiferDateToStr(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "HH:mm"
    let time1=dateformatter.string(from:time)
//        print("time1=",time1)
    return  time1
}


func modiferDateToStr_date_MD(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "MM-dd"
    let time1=dateformatter.string(from:time)
        print("MD=",time1)
    return  time1
}


func modiferDateToStr_date_YMD(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd"
    let time1=dateformatter.string(from:time)
//        print("time1=",time1)
    return  time1
}

func modiferDateToStr_date_hm(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let time1=dateformatter.string(from:time)
//        print("time1=",time1)
    return  time1
}

func modiferDateToDate(time:String)->Date{
    let dateformatter = DateFormatter.init()
    dateformatter.dateFormat = "HH:mm"
    let time2=dateformatter.date(from: time)
//        print("time2=",time2!)
    return  time2!
}

func modiferDateToStr_hh(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "HH"
    let hour=dateformatter.string(from:time)
//        print("hour=",hour)
    return  hour
}

func modiferDateToStr_mm(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "mm"
    let minute=dateformatter.string(from:time)
//        print("minute=",minute)
    return  minute
}

func modiferDateToStr_ss(time:Date)->String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "ss"
    let seconds=dateformatter.string(from:time)
//        print("minute=",minute)
    return  seconds
}

func timeInterval(date:Date)->Int{
    let nowTime=Date.now
    let nowH=Int(modiferDateToStr_hh(time: nowTime))!
    let nowM=Int(modiferDateToStr_mm(time: nowTime))!
    let nowS=Int(modiferDateToStr_ss(time: nowTime))!
    let dateH=Int(modiferDateToStr_hh(time: date))!
    let dateM=Int(modiferDateToStr_mm(time: date))!
    let nowSecond=nowH*60*60+nowM*60+nowS
    let dateSecond=dateH*60*60+dateM*60
//    print("intervalHour=",intervalHour)
    print(nowH,nowM,nowS,dateH,dateM)
    let seconds=nowSecond-dateSecond
    print("seconds",seconds)
    return seconds
}

struct MyDatePicker: UIViewRepresentable {
    
    @Binding var selection: Date
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MyDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: "zh_GB")
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }
    
    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyDatePicker>) {
        picker.minuteInterval = self.minuteInterval
        picker.date = selection
        //        picker.date = Date.init()x/
        
        switch displayedComponents {
        case .hourAndMinute:
            picker.datePickerMode = .time
        case .date:
            picker.datePickerMode = .date
        case [.hourAndMinute, .date]:
            picker.datePickerMode = .dateAndTime
        default:
            break
        }
    }
    
    class Coordinator {
        let datePicker: MyDatePicker
        init(_ datePicker: MyDatePicker) {
            self.datePicker = datePicker
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
            
        }
    }
}

struct TipsConDatePicker: UIViewRepresentable {
    
    
    @Binding var selection: Date
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents
    @Binding var lunarDp:Bool
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TipsConDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: "zh_GB")
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }
    
    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<TipsConDatePicker>) {
//        print("updateDate",lunarDp)
        picker.minuteInterval = self.minuteInterval
        picker.date = selection
//        picker.lun
        if lunarDp{
            picker.calendar=Calendar.init(identifier: .chinese)
        }
        else{
            picker.calendar=Calendar.init(identifier: .iso8601)
        }
        //        picker.date = Date.init()x/
        
        switch displayedComponents {
        case .hourAndMinute:
            picker.datePickerMode = .time
        case .date:
            picker.datePickerMode = .date
        case [.hourAndMinute, .date]:
            picker.datePickerMode = .dateAndTime
        default:
            break
        }
    }
    
    class Coordinator {
        let datePicker: TipsConDatePicker
        init(_ datePicker: TipsConDatePicker) {
            self.datePicker = datePicker
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
//            datePicker.lunarDp = sender.isHidden
        }
    }
}
