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

public class DayCounter {
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
    
    /**
    *  Construct a generic day counter (Actual/365.25 convention is used)
    */
    public init() {
        impl = DayCounter.Impl()
    }
    
    public func name() -> String {
        return impl.name()
    }
    
    public func shortName() -> String {
        return impl.shortName()
    }
    
    /**
    *  Returns the number of days between two dates based on the day counter
    *
    *  @param date1 Starting date
    *  @param date2 End date
    *
    *  @return the number of days between two dates based on the day counter
    */
    public func dayCount(date1 : Date, date2 : Date) -> Int {
        return impl.dayCount(date1, date2: date2)
    }
    
    
    /**
    *  Returns the day count fraction (i.e., year fraction) between two dates based on the day counter
    *
    *  @param date1              Starting date
    *  @param date2              End date
    *  @param referenceStartDate Reference start date (used for actual/actual)
    *  @param referenceEndDate   Reference end date (used for actual/actual)
    *
    *  @return a double representing the day count fraction
    */
    public func dayCountFraction(date1 : Date, date2 : Date, referenceStartDate : Date = Date(), referenceEndDate : Date = Date()) -> Double {
        return impl.dayCountFraction(date1, date2: date2, referenceStartDate: referenceStartDate, referenceEndDate: referenceEndDate)
    }
    
}