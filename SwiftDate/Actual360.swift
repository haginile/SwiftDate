//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Actual360.swift
//  SHSLib
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

class Actual360 : DayCounter {
    class Actual360Impl : DayCounter.Impl {
        override func name() -> String { return "Actual/360" }
        override func shortName() -> String { return "Actual/360" }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 360.0
        }
    }
    
    init() {
        super.init()
        impl = Actual360.Actual360Impl()
    }
}