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
            
            if ((y == 2007 && m == 4 && d == 6) ||
                (y == 2010 && m == 4 && d == 2) ||
                (y == 2012 && m == 4 && d == 6) ||
                (y == 2015 && m == 4 && d == 3)) {
                    return true
            }
            if ((y == 1999 && m == 4 && d == 2) ||
                (y == 2006 && m == 11 && d == 10) ||
                (y == 2000 && m == 11 && d == 10)) {
                    return true;
            }
            
            
            if (w == Weekday.Saturday || w == Weekday.Sunday) {
                return false
            }
            
            // New Year's Day (possibly moved to Monday if on Sunday) || // Martin Luther King's birthday (third Monday in January)
            if ((d == 1 || (d == 2 && w == Weekday.Monday)) && m == 1) {
                return false
            }
            if ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 1) {
                return false
            }
            
            // Washington's birthday (third Monday in February) || // Good Friday
            if ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 2) || (dd == em - 3) {
                return false
            }

            // Memorial Day (last Monday in May) || // Independence Day (Monday if Sunday or Friday if Saturday)
            if (d >= 25 && w == Weekday.Monday && m == 5) {
                return false
            }
            if ( ((d == 4 || (d == 5 && w == Weekday.Monday) || (d == 3 && w == Weekday.Friday)) && m == 7)) {
                return false
            }
                
            // Labor Day (first Monday in September) || // Columbus Day (second Monday in October)
            if ((d <= 7 && w == Weekday.Monday && m == 9) || ((d >= 8 && d <= 14) && w == Weekday.Monday && m == 10)) {
                return false
            }
            
            // Veteran's Day (Monday if Sunday or Friday if Saturday) || // Thanksgiving Day (fourth Thursday in November)
            if ( ((d == 11 || (d == 12 && w == Weekday.Monday)
                || (d == 10 && w == Weekday.Friday)) && m == 11)
                || ((d >= 22 && d <= 28) && w == Weekday.Thursday && m == 11) ) {
                    return false
            }
            
            // Christmas (Monday if Sunday or Friday if Saturday)
            if ((d == 25 || (d == 26 && w == Weekday.Monday) || (d == 24 && w == Weekday.Friday)) && m == 12) {
                return false
            }
            
            // Hurricane Sandy & Mourning of Regan
            if ((d == 30 && m == 10 && y == 2012) || (d == 11 && m == 6  && y == 2004)) {
                return false
            }
            return true
        }
    }
    
    public override init() {
        super.init()
        impl = USSettlementCalendar.USSettlementImpl()
    }
    
}


public class USNYSECalendar : Calendar {
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
            
            if (w == Weekday.Sunday || w == Weekday.Saturday) {
                return false
            }
            // New Year's Day (possibly moved to Monday if on Sunday)
            if ((d == 1 || (d == 2 && w == Weekday.Monday)) && m == 1) {
                return false
            }
            // Washington's birthday (third Monday in February)
            if ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 2) {
                return false
            }
            // Good Friday
            if (dd == em-3) {
                return false
            }
            // Memorial Day (last Monday in May)
            if (d >= 25 && w == Weekday.Monday && m == 5) {
                return false
            }
            // Independence Day (Monday if Sunday or Friday if Saturday)
            if (((d == 4 || (d == 5 && w == Weekday.Monday) ||
                (d == 3 && w == Weekday.Friday)) && m == 7)) {
                    return false
            }
            
            if (
            // Labor Day (first Monday in September)
                (d <= 7 && w == Weekday.Monday && m == 9)) {
                    return false
            }

            if (
            // Thanksgiving Day (fourth Thursday in November)
                ((d >= 22 && d <= 28) && w == Weekday.Thursday && m == 11)) {
                    return false
            }

            if (
            // Christmas (Monday if Sunday or Friday if Saturday)
            ((d == 25 || (d == 26 && w == Weekday.Monday) ||
            (d == 24 && w == Weekday.Friday)) && m == 12)
                ) {
                return false;
            }
            
            if (y >= 1998) {
                if (// Martin Luther King's birthday (third Monday in January)
                    ((d >= 15 && d <= 21) && w == Weekday.Monday && m == 1)) {
                        return false
                }
                // President Reagan's funeral
                if (y == 2004 && m == 6 && d == 11) {
                    return false
                }
                // September 11, 2001
                if (y == 2001 && m == 9 && (11 <= d && d <= 14)) {
                    return false
                }
                // President Ford's funeral
                if (y == 2007 && m == 1 && d == 2) {
                        return false;
                }
            } else if (y <= 1980) {
                if (// Presidential election days
                    ((y % 4 == 0) && m == 11 && d <= 7 && w == Weekday.Tuesday)) {
                        return false
                }
                if (
                // 1977 Blackout
                    y == 1977 && m == 7 && d == 14) {
                        return false
                }
                // Funeral of former President Lyndon B. Johnson.
                if (y == 1973 && m == 1 && d == 25) {
                    return false
                }
                // Funeral of former President Harry S. Truman
                if (y == 1972 && m == 12 && d == 28) {
                    return false
                }
                // National Day of Participation for the lunar exploration.
                if (y == 1969 && m == 7 && d == 21) {
                    return false
                }
                // Funeral of former President Eisenhower.
                if (y == 1969 && m == 3 && d == 31) {
                    return false
                }
                // Closed all day - heavy snow.
                if (y == 1969 && m == 2 && d == 10) {
                    return false
                        
                }
                if (
                // Day after Independence Day.
                y == 1968 && m == 7 && d == 5) {
                    return false
                }
                if (
                // June 12-Dec. 31, 1968
                // Four day week (closed on Wednesdays) - Paperwork Crisis
                 y == 1968 && dd >= 163 && w == Weekday.Wednesday) {
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
    
    public override init() {
        super.init()
        impl = USNYSECalendar.USNYSEImpl()
    }
    
}