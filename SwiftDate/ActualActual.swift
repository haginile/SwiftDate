//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  ActualActual.swift
//  SwiftDate
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

public class ActualActual : DayCounter {
    
    public enum Convention {
        case ISMA, Bond,
        ISDA, Historical, Actual365
    }
    
    class ISMA_Impl : DayCounter.Impl {
        override func name() -> String { return "Actual/Actual (ISMA)" }
        override func shortName() -> String { return "Actual/Actual" }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {

            if (date1 == date2) {
                return 0.0
            }
            if (date1 > date2) {
                return dayCountFraction(date2, date2: date1, referenceStartDate: referenceStartDate, referenceEndDate: referenceEndDate)
            }
            
            var refPeriodStart = (referenceStartDate != Date() ? referenceStartDate : date1)
            var refPeriodEnd = (referenceEndDate != Date() ? referenceEndDate : date2)
            
            var months = Int(0.5 + 12 * Double(refPeriodEnd - refPeriodStart) / 365.0)
            if (months == 0) {
                refPeriodStart = date1
                refPeriodEnd = date1.addYears(1)
                months = 12
            }
            
            let period = Double(months) / 12.0
            
            if (date2 <= refPeriodEnd) {
                if (date1 >= refPeriodStart) {
                    return period * Double(dayCount(date1, date2 : date2)) / Double(dayCount(refPeriodStart, date2 : refPeriodEnd))
                } else {
                    let prevRef = refPeriodStart.addMonths(months)
                    if (date2 > refPeriodStart) {
                        return dayCountFraction(date1, date2: refPeriodStart, referenceStartDate: prevRef, referenceEndDate: refPeriodStart) + dayCountFraction(refPeriodStart, date2: date2, referenceStartDate: refPeriodStart, referenceEndDate: refPeriodEnd)
                    } else {
                        return dayCountFraction(date1, date2: date2, referenceStartDate: prevRef, referenceEndDate: refPeriodStart)
                    }
                }
                
            } else {
                var sum = dayCountFraction(date1, date2: refPeriodEnd, referenceStartDate: refPeriodStart, referenceEndDate: refPeriodEnd)
                var i = 0
                var newRefStart = Date(), newRefEnd = Date()
                
                while true {
                    newRefStart = refPeriodEnd.addMonths(months * i)
                    newRefEnd = refPeriodEnd.addMonths(months * (i + 1))
                    if(date2 < newRefEnd) {
                        break
                    } else {
                        sum += period
                        i += 1
                    }
                }
                
                sum += dayCountFraction(newRefStart, date2: date2, referenceStartDate: newRefStart, referenceEndDate: newRefEnd)
                return sum
                
            }
            
        }
    }
    
    class ISDA_Impl : DayCounter.Impl {
        override func name() -> String { return "Actual/Actual (ISDA)" }
        override func shortName() -> String { return "Actual/Actual" }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            
            if (date1 == date2) {
                return 0
            }
            
            if (date1 > date2) {
                return dayCountFraction(date2, date2: date1, referenceStartDate: referenceStartDate, referenceEndDate: referenceEndDate)
            }
            
            let y1 = date1.year()
            let y2 = date2.year()
            let dib1 = (Date.isLeap(y1) ? 366.0 : 365.0)
            let dib2 = (Date.isLeap(y2) ? 366.0 : 365.0)
            var sum = Double(y2 - y1 - 1)
            sum += Double(dayCount(date1, date2: Date(year: y1 + 1, month: 1, day: 1))) / dib1
            sum += Double(dayCount(Date(year: y2, month: 1, day: 1), date2: date2)) / dib2
            return sum
        }
    }
    
    public init(convention : ActualActual.Convention = ActualActual.Convention.ISDA) {
        super.init()
        
        switch convention {
        case .ISMA, .Bond:
            impl = ActualActual.ISMA_Impl()
        case .ISDA, .Historical, .Actual365:
            impl = ActualActual.ISDA_Impl()
        }
    }
}