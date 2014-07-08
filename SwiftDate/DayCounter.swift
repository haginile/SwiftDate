//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  DayCounter.swift
//  SHSLib
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

class DayCounter {
    class Impl {
        func name() -> String { return "Day Counter" }
        
        func shortName() -> String { return "Day Counter" }
        
        func dayCount(date1 : Date, date2 : Date) -> Int {
            return date2 - date1
        }
        
        func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 365.25
        }
    }
    
    var impl : Impl
    
    init() {
        impl = DayCounter.Impl()
    }
    
    func name() -> String {
        return impl.name()
    }
    
    func shortName() -> String {
        return impl.shortName()
    }
    
    func dayCount(date1 : Date, date2 : Date) -> Int {
        return impl.dayCount(date1, date2: date2)
    }
    
    func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
        return impl.dayCountFraction(date1, date2: date2, referenceStartDate: referenceStartDate, referenceEndDate: referenceEndDate)
    }
    
}