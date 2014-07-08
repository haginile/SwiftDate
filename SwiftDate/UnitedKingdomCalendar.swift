//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  UnitedKingdomCalendar.swift
//  SwiftDate
//
//  Created by Helin Gai on 7/7/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation


class UKSettlementCalendar : Calendar {
    class UKSettlementImpl : Calendar.Impl {
        
        override func name() -> String {
            return "UK Settlement Calendar"
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
                // New Year's Day (possibly moved to Monday)
                || ((d == 1 || ((d == 2 || d == 3) && w == Weekday.Monday)) &&
                m == 1)
                // Good Friday
                || (dd == em-3)
                // Easter Monday
                || (dd == em)
                // first Monday of May (Early May Bank Holiday)
                || (d <= 7 && w == Weekday.Monday && m == 5)
                // last Monday of May (Spring Bank Holiday)
                || (d >= 25 && w == Weekday.Monday && m == 5 && y != 2002)
                // last Monday of August (Summer Bank Holiday)
                || (d >= 25 && w == Weekday.Monday && m == 8)
                // Christmas (possibly moved to Monday or Tuesday)
                || ((d == 25 || (d == 27 && (w == Weekday.Monday || w == Weekday.Tuesday)))
                && m == 12)
                // Boxing Day (possibly moved to Monday or Tuesday)
                || ((d == 26 || (d == 28 && (w == Weekday.Monday || w == Weekday.Tuesday)))
                && m == 12)
                // June 3rd, 2002 only (Golden Jubilee Bank Holiday)
                // June 4rd, 2002 only (special Spring Bank Holiday)
                || ((d == 3 || d == 4) && m == 6 && y == 2002)
                // December 31st, 1999 only
                || (d == 31 && m == 12 && y == 1999)) {
                return false;
            }
            return true;
        }
    }
    
    init() {
        super.init()
        impl = UKSettlementCalendar.UKSettlementImpl()
    }
    
}

