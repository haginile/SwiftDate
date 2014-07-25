//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Thirty360.swift
//  SHSLib
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

public class Thirty360 : DayCounter {
    
    public enum Convention {
        case USA, BondBasis,            // 30/360 US - Bond Basis
        European, EurobondBasis,        // 30/360E
        Italian,                        // 30/360 Italian
        PSA                             // 30/360 PSA
    }
    
    class US_Impl : DayCounter.Impl {
        override func name() -> String { return "30/360 (Bond Basis)" }
        override func shortName() -> String { return "30/360" }
        
        override func dayCount(date1: Date, date2: Date) -> Int {
            var dd1 : Int = date1.day()
            var dd2 : Int = date2.day()
            var mm1 : Int = date1.month()
            var mm2 : Int = date2.month()
            var yy1 : Int = date1.year()
            var yy2 : Int = date2.year()

            if (dd2 == 31 && dd1 < 30) {
                dd2 = 1
                mm2 += 1
            }
            
            var o = 360 * (yy2 - yy1)
            o += 30 * (mm2 - mm1 - 1)
            o += max(0, 30 - dd1)
            o +=  min(30, dd2)
            return o
        }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 360.0
        }
    }
    
    class EU_Impl : DayCounter.Impl {
        override func name() -> String { return "30E/360 (Eurobond Basis)" }
        override func shortName() -> String { return "30/360" }
        
        override func dayCount(date1: Date, date2: Date) -> Int {
            var dd1 : Int = date1.day()
            var dd2 : Int = date2.day()
            var mm1 : Int = date1.month()
            var mm2 : Int = date2.month()
            var yy1 : Int = date1.year()
            var yy2 : Int = date2.year()
            
            var o = 360 * (yy2 - yy1)
            o += 30 * (mm2 - mm1 - 1)
            o += max(0, 30 - dd1)
            o +=  min(30, dd2)
            return o
        }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 360.0
        }
    }
    
    class IT_Impl : DayCounter.Impl {
        override func name() -> String { return "30/360 (Italian)" }
        override func shortName() -> String { return "30/360" }
        
        override func dayCount(date1: Date, date2: Date) -> Int {
            var dd1 : Int = date1.day()
            var dd2 : Int = date2.day()
            var mm1 : Int = date1.month()
            var mm2 : Int = date2.month()
            var yy1 : Int = date1.year()
            var yy2 : Int = date2.year()
            
            if mm1 == 2 && dd1 > 27 {
                dd1 = 30
            }
            
            if mm2 == 2 && dd2 > 27 {
                dd2 = 30
            }
            
            var o = 360 * (yy2 - yy1)
            o += 30 * (mm2 - mm1 - 1)
            o += max(0, 30 - dd1)
            o +=  min(30, dd2)
            return o
        }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 360.0
        }
    }
    
    class PSA_Impl : DayCounter.Impl {
        override func name() -> String { return "30/360 (PSA)" }
        override func shortName() -> String { return "30/360" }
        
        override func dayCount(date1: Date, date2: Date) -> Int {
            var dd1 : Int = date1.day()
            var dd2 : Int = date2.day()
            var mm1 : Int = date1.month()
            var mm2 : Int = date2.month()
            var yy1 : Int = date1.year()
            var yy2 : Int = date2.year()
            
            if dd1 == 31 || date2 == Date.endOfMonth(date2) {
                dd1 = 30
            }
            
            if dd2 == 31 && dd1 == 30 {
                dd2 = 30
            }
            
            var o = 360 * (yy2 - yy1)
            o += 30 * (mm2 - mm1)
            o += dd2 - dd1
            return o
        }
        
        override func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
            return Double(dayCount(date1, date2: date2)) / 360.0
        }
    }
    
    public init(convention : Thirty360.Convention = Thirty360.Convention.BondBasis) {
        super.init()
        
        switch convention {
        case .USA, .BondBasis:
            impl = Thirty360.US_Impl()
        case .European, .EurobondBasis:
            impl = Thirty360.EU_Impl()
        case .Italian:
            impl = Thirty360.IT_Impl()
        case .PSA:
            impl = Thirty360.PSA_Impl()
        }
    }
}