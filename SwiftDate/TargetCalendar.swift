//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  TargetCalendar.swift
//  SwiftDate
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

public class TARGETCalendar : Calendar {
    class TARGETImpl : Calendar.Impl {
        
        override func name() -> String {
            return "TARGET Calendar"
        }
        
        override func isWeekend(weekday: Weekday) -> Bool {
            if (weekday == Weekday.Saturday || weekday == Weekday.Sunday) {
                return false
            }
            return true
        }
        
        override func isBizDay(date: Date) -> Bool {
            var w = date.weekday();
            var d = date.day();
            var dd = date.dayOfYear();
            var m = date.month();
            var y = date.year();
            var em = Calendar.Impl.easterMonday(y);
            
            if (w == Weekday.Saturday || w == Weekday.Sunday
                // New Year's Day
                || (d == 1  && m == 1)
                // Good Friday
                || (dd == em-3 && y >= 2000)
                // Easter Monday
                || (dd == em && y >= 2000)
                // Labour Day
                || (d == 1  && m == 5 && y >= 2000)
                // Christmas
                || (d == 25 && m == 12)
                // Day of Goodwill
                || (d == 26 && m == 12 && y >= 2000)
                // December 31st, 1998, 1999, and 2001 only
                || (d == 31 && m == 12 &&
                (y == 1998 || y == 1999 || y == 2001))) {
                return false;
            }
            
            return true;
        }
    }
    
    public init() {
        super.init()
        impl = TARGETCalendar.TARGETImpl()
    }
    
}

