//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  DateHelpers.swift
//  SHSLib
//
//  Created by Helin Gai on 7/6/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

extension Array {
    var last: T {
    return self[self.endIndex - 1]
    }
}

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
    
    func find_first_of(string : String) -> Int {
        var i = 0
        for c in self {
            if string.rangeOfString(String(c)) {
                return i
            }
            i += 1
        }
        return -1
    }
}

extension Int {
    var days: Term { get { return Term(length: self, timeUnit: TimeUnit.Day) } }
    var weeks: Term { get { return Term(length: self, timeUnit: TimeUnit.Week) } }
    var months: Term { get { return Term(length: self, timeUnit: TimeUnit.Month) } }
    var years: Term { get { return Term(length: self, timeUnit: TimeUnit.Year) } }
}