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
            let w = date.weekday();
            let d = date.day();
            let dd = date.dayOfYear();
            let m = date.month();
            let y = date.year();
            let em = Calendar.Impl.easterMonday(y);
            
            if (w == Weekday.Saturday || w == Weekday.Sunday) {
                return false
            }
            // New Year's Day
            if (d == 1  && m == 1) {
                return false
            }
                // Good Friday
            if (dd == em-3 && y >= 2000) {
                return false
            }
                // Easter Monday
            if (dd == em && y >= 2000) {
                return false
            }
                // Labour Day
            if (d == 1  && m == 5 && y >= 2000) {
                return false
            }
                // Christmas
            if (d == 25 && m == 12) {
                return false
            }
                // Day of Goodwill
            if (d == 26 && m == 12 && y >= 2000) {
                return false
            }
                // December 31st, 1998, 1999, and 2001 only
            if (d == 31 && m == 12 &&
                (y == 1998 || y == 1999 || y == 2001)) {
                return false
            }
            
            return true;
        }
    }
    
    public override init() {
        super.init()
        impl = TARGETCalendar.TARGETImpl()
    }
    
}

