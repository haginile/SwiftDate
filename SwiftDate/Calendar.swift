//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Calendar.swift
//  SHSLib
//
//  Created by Helin Gai on 6/30/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.

import Foundation

class Calendar {
    
    class Impl {
        
        func name() -> String {
            return "Generic Calendar";
        }
        
        func isBizDay(date : Date) -> Bool {
            return true;
        }
        
        func isWeekend(weekday : Weekday) -> Bool {
            return (weekday == Weekday.Saturday || weekday == Weekday.Sunday)
        }
        
        class func easterMonday(year : Int) -> Int {
            let EasterMonday : [Int] = [
                98,  90, 103,  95, 114, 106,  91, 111, 102,         // 1901-1909
                87, 107,  99,  83, 103,  95, 115,  99,  91, 111,    // 1910-1919
                96,  87, 107,  92, 112, 103,  95, 108, 100,  91,    // 1920-1929
                111,  96,  88, 107,  92, 112, 104,  88, 108, 100,   // 1930-1939
                85, 104,  96, 116, 101,  92, 112,  97,  89, 108,    // 1940-1949
                100,  85, 105,  96, 109, 101,  93, 112,  97,  89,   // 1950-1959
                109,  93, 113, 105,  90, 109, 101,  86, 106,  97,   // 1960-1969
                89, 102,  94, 113, 105,  90, 110, 101,  86, 106,    // 1970-1979
                98, 110, 102,  94, 114,  98,  90, 110,  95,  86,    // 1980-1989
                106,  91, 111, 102,  94, 107,  99,  90, 103,  95,   // 1990-1999
                115, 106,  91, 111, 103,  87, 107,  99,  84, 103,   // 2000-2009
                95, 115, 100,  91, 111,  96,  88, 107,  92, 112,    // 2010-2019
                104,  95, 108, 100,  92, 111,  96,  88, 108,  92,   // 2020-2029
                112, 104,  89, 108, 100,  85, 105,  96, 116, 101,   // 2030-2039
                93, 112,  97,  89, 109, 100,  85, 105,  97, 109,    // 2040-2049
                101,  93, 113,  97,  89, 109,  94, 113, 105,  90,   // 2050-2059
                110, 101,  86, 106,  98,  89, 102,  94, 114, 105,   // 2060-2069
                90, 110, 102,  86, 106,  98, 111, 102,  94, 114,    // 2070-2079
                99,  90, 110,  95,  87, 106,  91, 111, 103,  94,    // 2080-2089
                107,  99,  91, 103,  95, 115, 107,  91, 111, 103,   // 2090-2099
                88, 108, 100,  85, 105,  96, 109, 101,  93, 112,    // 2100-2109
                97,  89, 109,  93, 113, 105,  90, 109, 101,  86,    // 2110-2119
                106,  97,  89, 102,  94, 113, 105,  90, 110, 101,   // 2120-2129
                86, 106,  98, 110, 102,  94, 114,  98,  90, 110,    // 2130-2139
                95,  86, 106,  91, 111, 102,  94, 107,  99,  90,    // 2140-2149
                103,  95, 115, 106,  91, 111, 103,  87, 107,  99,   // 2150-2159
                84, 103,  95, 115, 100,  91, 111,  96,  88, 107,    // 2160-2169
                92, 112, 104,  95, 108, 100,  92, 111,  96,  88,    // 2170-2179
                108,  92, 112, 104,  89, 108, 100,  85, 105,  96,   // 2180-2189
                116, 101,  93, 112,  97,  89, 109, 100,  85, 105    // 2190-2199
            ];
            return EasterMonday[year-1901];
        }
    }
    
    var impl : Impl
    
    init() {
        impl = Calendar.Impl()
    }
    
    init(name : String) {
        impl = Calendar.Impl()
    }
    
    func description() -> String {
        return impl.name()
    }
    
    /**
    *  Returns whether a date is a business day
    *
    *  @param date The date to be checked
    *
    *  @return a boolean representing whether or not the date is a business day
    */
    func isBizDay(date : Date) -> Bool {
        return impl.isBizDay(date)
    }
    
    func isWeekend(weekday : Weekday) -> Bool {
        return impl.isWeekend(weekday)
    }
    
    func bizDaysBetween(fromDate : Date, toDate : Date, includeFirst : Bool = true, includeLast : Bool = false) -> Int {
        var wd = 0
        if (fromDate != toDate) {
            if (fromDate < toDate) {
                var d = fromDate
                while d < toDate {
                    if isBizDay(d) {
                        ++wd
                    }
                    d += 1
                }
                if isBizDay(toDate) {
                    ++wd
                }
            } else if (fromDate > toDate) {
                var d = toDate
                while d < fromDate {
                    if isBizDay(d) {
                        ++wd
                    }
                    d += 1
                }
                
                if (isBizDay(toDate)) {
                    ++wd
                }
            }
            
            if isBizDay(fromDate) && !includeFirst {
                wd -= 1
            }
            
            if isBizDay(toDate) && !includeLast {
                wd -= 1
            }
            
            if (fromDate > toDate) {
                wd = -wd
            }
            
        }
        return wd
    
    }
    
    func nextBizDay(date : Date) -> Date {
        var d = date
        do {
            d += 1
        } while (!isBizDay(d))
        return d
    }
    
    
    func prevBizDay(date : Date) -> Date {
        var d = date
        do {
            d -= 1
        } while (!isBizDay(d))
        return d
    }
    
    
    func adjust(date : Date, bizDayRule : BizDayRule = BizDayRule.Unadjust, timeUnit : TimeUnit = TimeUnit.Month) -> Date {
        if (isBizDay(date)) {
            return date
        }
        
        switch bizDayRule {
        case BizDayRule.ModifiedFollowing:
            var nextDate = nextBizDay(date)
            return Date.samePeriod(date, date2: nextDate, timeUnit: timeUnit) ? nextDate : prevBizDay(date)
        case BizDayRule.ModifiedPrevious:
            var prevDate = prevBizDay(date)
            return Date.samePeriod(date, date2: prevDate, timeUnit: timeUnit) ? prevDate : nextBizDay(date)
        case BizDayRule.Following:
            return nextBizDay(date)
        case BizDayRule.Previous:
            return prevBizDay(date)
        case BizDayRule.Unadjust:
            return date
        default:
            break;
        }
        
    }
    
    func addDays(date : Date, numberOfDays : Int, bizDayRule : BizDayRule) -> Date {
        return adjust(date + numberOfDays, bizDayRule: bizDayRule)
    }
    
    func addBizDays(date : Date, numberOfDays : Int, bizDayRule : BizDayRule) -> Date {
        var next = date
        next = adjust(next, bizDayRule : bizDayRule)
        var nd = numberOfDays
        while (nd > 0) {
            next = nextBizDay(next)
            nd -= 1
        }
        return next
    }
    
    func addMonths(date : Date, numberOfMonths : Int, bizDayRule : BizDayRule, rollDay : RollDay = RollDay.Zero) -> Date {
        return adjust(date.addMonths(numberOfMonths, rollDay: rollDay), bizDayRule: bizDayRule)
    }
    
    func addYears(date : Date, numberOfYears : Int, bizDayRule : BizDayRule, rollDay : RollDay = RollDay.Zero) -> Date {
        return adjust(date.addYears(numberOfYears, rollDay: rollDay), bizDayRule: bizDayRule)
    }

    func add(date : Date, term : Term, bizDayRule : BizDayRule, rollDay : RollDay = RollDay.Zero) -> Date {
        return adjust(date.add(term, rollDay: rollDay), bizDayRule : bizDayRule)
    }

    
}
