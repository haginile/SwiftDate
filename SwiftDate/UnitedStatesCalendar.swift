//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  UnitedStatesCalendar.swift
//  SHSLib
//
//  Created by Helin Gai on 7/6/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

public class USSettlementCalendar : Calendar {
    class USSettlementImpl : Calendar.Impl {
        
        override func name() -> String {
            return "US Settlement Calendar"
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
            
            //@@@ I HAD TO BREAK THIS APART BECAUSE XCODE WAS GOING NUTS
            
            if (w == Weekday.Saturday || w == Weekday.Sunday
                // New Year's Day (possibly moved to Monday if on Sunday) || // Martin Luther King's birthday (third Monday in January)
                || ((d == 1 || (d == 2 && w == Weekday.Monday)) && m == 1) || ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 1)
                // Washington's birthday (third Monday in February) || // Good Friday
                || ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 2) || (dd == em - 3)
                ) {
                    return false
            }
            if  (  // Memorial Day (last Monday in May) || // Independence Day (Monday if Sunday or Friday if Saturday)
                (d >= 25 && w == Weekday.Monday && m == 5) || ((d == 4 || (d == 5 && w == Weekday.Monday) ||
                (d == 3 && w == Weekday.Friday)) && m == 7)
                // Labor Day (first Monday in September) || // Columbus Day (second Monday in October)
                || (d <= 7 && w == Weekday.Monday && m == 9) || ((d >= 8 && d <= 14) && w == Weekday.Monday && m == 10)
                // Veteran's Day (Monday if Sunday or Friday if Saturday) || // Thanksgiving Day (fourth Thursday in November)
                ) {
                    return false
            }
            if ( ((d == 11 || (d == 12 && w == Weekday.Monday) || (d == 10 && w == Weekday.Friday)) && m == 11) || ((d >= 22 && d <= 28) && w == Weekday.Thursday && m == 11)
                // Christmas (Monday if Sunday or Friday if Saturday)
                || ((d == 25 || (d == 26 && w == Weekday.Monday) || (d == 24 && w == Weekday.Friday)) && m == 12)
                // Hurricane Sandy
                || (d == 30 && m == 10 && y == 2012)
                // Mourning of Regan
                || (d == 11 && m == 6 && y == 2004)
                ) {
                return false;
            }
            return true;
        }
    }
    
    public init() {
        super.init()
        impl = USSettlementCalendar.USSettlementImpl()
    }
    
}


class USNYSECalendar : Calendar {
    class USNYSEImpl : Calendar.Impl {
        
        override func name() -> String {
            return "US NYSE Calendar"
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
            
            if (w == Weekday.Sunday || w == Weekday.Saturday
            // New Year's Day (possibly moved to Monday if on Sunday)
            || ((d == 1 || (d == 2 && w == Weekday.Monday)) && m == 1)
            // Washington's birthday (third Monday in February)
            || ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 2)
            // Good Friday
            || (dd == em-3)
            // Memorial Day (last Monday in May)
            || (d >= 25 && w == Weekday.Monday && m == 5)
            // Independence Day (Monday if Sunday or Friday if Saturday)
            || ((d == 4 || (d == 5 && w == Weekday.Monday) ||
            (d == 3 && w == Weekday.Friday)) && m == 7)
            // Labor Day (first Monday in September)
            || (d <= 7 && w == Weekday.Monday && m == 9)
            // Thanksgiving Day (fourth Thursday in November)
            || ((d >= 22 && d <= 28) && w == Weekday.Thursday && m == 11)
            // Christmas (Monday if Sunday or Friday if Saturday)
            || ((d == 25 || (d == 26 && w == Weekday.Monday) ||
            (d == 24 && w == Weekday.Friday)) && m == 12)
                ) {
                return false;
            }
            if (y >= 1998) {
                if (// Martin Luther King's birthday (third Monday in January)
                ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 1)
                // President Reagan's funeral
                || (y == 2004 && m == 6 && d == 11)
                // September 11, 2001
                || (y == 2001 && m == 9 && (11 <= d && d <= 14))
                // President Ford's funeral
                || (y == 2007 && m == 1 && d == 2)
                    ) {
                        return false;
                }
            } else if (y <= 1980) {
                if (// Presidential election days
                ((y % 4 == 0) && m == 11 && d <= 7 && w == Weekday.Tuesday)
                // 1977 Blackout
                || (y == 1977 && m == 7 && d == 14)
                // Funeral of former President Lyndon B. Johnson.
                || (y == 1973 && m == 1 && d == 25)
                // Funeral of former President Harry S. Truman
                || (y == 1972 && m == 12 && d == 28)
                // National Day of Participation for the lunar exploration.
                || (y == 1969 && m == 7 && d == 21)
                // Funeral of former President Eisenhower.
                || (y == 1969 && m == 3 && d == 31)
                // Closed all day - heavy snow.
                || (y == 1969 && m == 2 && d == 10)
                // Day after Independence Day.
                || (y == 1968 && m == 7 && d == 5)
                // June 12-Dec. 31, 1968
                // Four day week (closed on Wednesdays) - Paperwork Crisis
                || (y == 1968 && dd >= 163 && w == Weekday.Wednesday)
                    ) {
                    return false;
                }
            } else {
                if (// Nixon's funeral
                    (y == 1994 && m == 4 && d == 27)
                    // Hurricane Sandy
                    || (d == 30 && m == 10 && y == 2012)
                    ) {
                        return false;
                }
            }
            
            return true;
        }
    }
    
    public init() {
        super.init()
        impl = USNYSECalendar.USNYSEImpl()
    }
    
}