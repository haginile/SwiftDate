//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  NL365.swift
//  SHSLib
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

public class NL365 : DayCounter {
    class NL365Impl : DayCounter.Impl {
        override func name() -> String { return "NL/360" }
        
        override func shortName() -> String { return "NL/360" }
        
        override func dayCount(date1: Date, date2: Date) -> Int {
            var dateAdjust = 0
            if Date.isLeap(date1.year()) && date1.month() < 3 && date2.month() >= 3 {
                dateAdjust -= 1
            }
            if Date.isLeap(date2.year()) && date2.year() > date1.year() && date2.month() >= 3 {
                dateAdjust -= 1
            }
            var i = date1.year() + 1
            while i < date2.year() {
                if Date.isLeap(i) {
                    dateAdjust -= 1
                }
                i = i + 1
            }
            return date2 - date1 + dateAdjust
        }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 365.0
        }
    }
    
    public init() {
        super.init()
        impl = NL365.NL365Impl()
    }
}