//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Actual365Fixed.swift
//  SHSLib
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

public class Actual365Fixed : DayCounter {
    class Actual365FixedImpl : DayCounter.Impl {
        override func name() -> String { return "Actual/365 (Fixed)" }
        
        override func shortName() -> String { return "Actual/365 (Fixed)" }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 365.0
        }
    }
    
    public init() {
        super.init()
        impl = Actual365Fixed.Actual365FixedImpl()
    }
}