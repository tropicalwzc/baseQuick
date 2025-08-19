//
//  TimeStampConvertView.swift
//  baseQuick
//
//  Created by wangzicheng on 2025/8/19.
//

import SwiftUI

struct TimeStampConvertView: View {
    @State private var input: String = ""
    @State private var output: String = ""
    @State private var currentGMTSec: Int = TimeZone.current.secondsFromGMT()
    @State private var specifiedGMTHour: String = String((TimeZone.current.secondsFromGMT()) / 3600)
    @State private var inited: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 2) {
                
                Button {
                    input = String(Int(Date().timeIntervalSince1970))
                } label: {
                    Text("Refresh")
                }
                .padding(.trailing, 6)
                
                Text("TS")
                TextField(text: $input, axis: .horizontal) {
                    Text("input normal text...")
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
                .textFieldStyle(.automatic)
                .frame(width: 260)
            }
            
            HStack(spacing: 2) {
                Text(verbatim:"GMT")
                
                TextField(text: $specifiedGMTHour, axis: .vertical) {
                    Text("")
                }
                .textFieldStyle(.automatic)
                .frame(width: 54)
            }
            
            HStack(spacing: 2) {
                Text("Date")
                TextField(text: $output, axis: .horizontal) {
                    Text("input normal text...")
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
                .textFieldStyle(.automatic)
                .frame(width: 300)
                
                Button {
                    refreshOutput(newVal: output)
                } label: {
                    Text("Calculate ts")
                }
                .padding(.leading, 6)
            }
        }
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
        .font(.system(size: 24, weight: .light))
        .onAppear {
            if !inited {
                inited = true
                input = String(Int(Date().timeIntervalSince1970))
            }
        }
        .onChange(of: input) { newVal in
            refreshInput(newVal: newVal)
        }
        .onChange(of: specifiedGMTHour) { newVal in
            refreshInput(newVal: input)
        }
    }
    
    func refreshOutput(newVal: String) {
        let preRes = getDisplayDateTimeStamp()
        if preRes > 0 {
            let preStr = String(preRes)
            if input != preStr {
                withAnimation {
                    input = preStr
                }
            }
        }
    }
    
    func refreshInput(newVal: String) {
        let newOutput = format(Date(timeIntervalSince1970: Double(newVal) ?? 0))
        if newOutput != output {
            withAnimation {
                output = newOutput
            }
        }
    }
    
    func format(_ date: Date) -> String {
        let formatter = dateFormatter("yyyy-MM-dd HH:mm:ss")
        let specifiedSec = (Int(specifiedGMTHour) ?? 8) * 3600
        return formatter.string(from: date.addingTimeInterval(TimeInterval(specifiedSec - currentGMTSec)))
    }
    
    func dateFormatter(_ fmtStr: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = fmtStr
        fmt.amSymbol = "AM"
        fmt.pmSymbol = "PM"
        return fmt
    }
    
    func getDisplayDateTimeStamp() -> Int {
        let res = getDateTimeStamp()
        let specifiedSec = (Int(specifiedGMTHour) ?? 8) * 3600
        let minus = Int(specifiedSec - currentGMTSec)
        if res > 0 {
            return res - minus
        } else {
            return res
        }
    }
    
    func getDateTimeStamp() -> Int {
        let pieces = output.split(separator: " ")
        if pieces.count == 2 {
            let dayPieces = pieces[0].split(separator: "-")
            if dayPieces.count == 3 {
                if let year = Int(dayPieces[0]),let month = Int(dayPieces[1]),let day = Int(dayPieces[2]){
                    let inPieces = pieces[1].split(separator: ":")
                    if inPieces.count == 3 {
                        if let hour = Int(inPieces[0]),let minute = Int(inPieces[1]),let second = Int(inPieces[2]) {
                            print("\(year) \(month) \(day) \(hour) \(minute) \(second)")
                            if let yearDate = Calendar.current.date(bySetting: .year, value: year, of: Date(timeIntervalSince1970: 0)) {
                                if let monthDate = Calendar.current.date(bySetting: .month, value: month, of: yearDate) {
                                    if let dayDate = Calendar.current.date(bySetting: .day, value: day, of: monthDate) {
                                        let start = Calendar.current.startOfDay(for: dayDate)
                                        return Int(start.addingTimeInterval(TimeInterval(hour * 3600 + minute * 60 + second)).timeIntervalSince1970)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return 0
    }
    
}
