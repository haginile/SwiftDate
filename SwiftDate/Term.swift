//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Term.swift
//  SHSLib
//
//  Created by Helin Gai on 6/30/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.

import Foundation

public enum TimeUnit {
    case Day,
    Week,
    Month,
    Year
}

/**
 *  Representation of a Term, such as "1D", "6M" & "1Y"
 *  Each term is composed of its length and its timeUnit.
 *  e.g., for "6M", its length = 6 and its timeUnit = TimeUnit.Month
 */
public class Term {
    
    public var timeUnit : TimeUnit = TimeUnit.Day
    public var length : Int = 0
    
    /**
    *  Default constructor constructs "0D"
    */
    public init() {
    }
    
    /**
    *  Construct a term from its length and the timeUnit
    */
    public init(length : Int, timeUnit : TimeUnit) {
        self.length = length
        self.timeUnit = timeUnit
    }
    
    /**
    *  Construct a term from a tenor string such as "6M"
    *  TODO: Fix bug with composite tenor strings such as "1Y6M"
    */
    public init(string : String) {
        let t = Term.parse(string)
        self.length = t.length
        self.timeUnit = t.timeUnit
    }
    
    /**
    *  Returns the day count fraction (year fraction) corresponding to the term
    *  e.g., the DCF for "1Y" is simply 1, while the DCF for "6M" is 0.5
    *
    *  @return a double corresponding to the year fraction of the term
    */
    public func dayCountFraction() -> Double {
        switch (timeUnit) {
        case TimeUnit.Year:
            return Double(length)
        case TimeUnit.Month:
            return Double(length) / 12.0
        case TimeUnit.Week:
            return Double(length) / 52.0
        case TimeUnit.Day:
            return Double(length) / 365.242
        }
    }
    
    /**
    *  Returns the frequency (i.e., number of times each year) of the term
    *  e.g., the frequency of "6M" is 2 (twice a year)
    *
    *  @return a double corresponding to the frequency of the term
    */
    public func frequency() -> Double {
        switch (timeUnit) {
        case TimeUnit.Year:
            return 1.0 / Double(length)
        case TimeUnit.Month:
            return 12.0 / Double(length)
        case TimeUnit.Week:
            return 52.0 / Double(length)
        case TimeUnit.Day:
            return 365.242 / Double(length)
        }
    }
    
    /**
    *  Returns the string representation of the term
    *
    *  @return string representing the term
    */
    public func description() -> String {
        var output = String(length)
        switch (timeUnit) {
        case TimeUnit.Day:
            output += "D"
        case TimeUnit.Week:
            output += "W"
        case TimeUnit.Month:
            output += "M"
        case TimeUnit.Year:
            output += "Y"
        }
        return output
    }
    
    /**
    *  Add two terms together
    *  e.g., adding "1Y" and "6M" returns "18M"
    *
    *  @param term1 The first term to be addded
    *  @param term2 The second term to be added
    *
    *  @return the combined term
    */
    public class func addTerms(term1 : Term, term2 : Term) -> Term {
        var length = 0
        var timeUnit = TimeUnit.Day
        
        if (term1.timeUnit == term2.timeUnit) {
            timeUnit = term1.timeUnit
            length = term1.length + term2.length
        } else {
            switch (term1.timeUnit) {
            case TimeUnit.Year:
                if (term2.timeUnit == TimeUnit.Month) {
                    length = term1.length * 12 + term2.length
                    timeUnit = TimeUnit.Month
                } else {
                    assert(false, "#Cannot add these tenors")
                }
                
            case TimeUnit.Month:
                if (term2.timeUnit == TimeUnit.Year) {
                    length = term1.length + term2.length * 12
                    timeUnit = TimeUnit.Month
                } else {
                    assert(false, "#Cannot add these tenors")
                }
        
            case TimeUnit.Week:
                if (term2.timeUnit == TimeUnit.Day) {
                    length = term1.length * 7 + term2.length
                    timeUnit = TimeUnit.Day
                } else {
                    assert(false, "#Cannot add these tenors")
                }
    
            case TimeUnit.Day:
                if (term2.timeUnit == TimeUnit.Week) {
                    length = term1.length + term2.length * 7
                    timeUnit = TimeUnit.Day
                } else {
                assert(false, "#Cannot add these tenors")
                }
            }
        }

        return Term(length: length, timeUnit: timeUnit)
    }
    
    /**
    *  Add a term to self
    *
    *  @param term The term to be added
    *
    *  @return a new term
    */
    public func addTerm(term : Term) -> Term {
        return Term.addTerms(self, term2 : term)
    }
    
    /**
    *  Subtract a term to self
    *
    *  @param term The term to be subtracted
    *
    *  @return a new term
    */
    public func subTerm(term : Term) -> Term {
        return Term.addTerms(self, term2 : -term)
    }
    
    
    class func parseOneTerm(string : String) -> Term {
        let str = string.uppercaseString
        let len = str.characters.count
        let length = Int(str[0..<(len - 1)])
        let timeUnit = str[len-1]
        
        switch timeUnit {
        case "D":
            return Term(length: length!, timeUnit: TimeUnit.Day)
        case "W":
            return Term(length: length!, timeUnit: TimeUnit.Week)
        case "M":
            return Term(length: length!, timeUnit: TimeUnit.Month)
        case "Y":
            return Term(length: length!, timeUnit: TimeUnit.Year)
        default:
            return Term()
        }
        
    }
    
    class func parse(string : String) -> Term {
        
        return parseOneTerm(string)
        
//        var subStrings = [String]()
//        var reducedString = string
//        
//        var iPos = 0, reducedStringDim = 100000
//        while (reducedStringDim > 0) {
//            iPos = reducedString.find_first_of("DdWwMmYyZz")
//            var subStringDim = iPos + 1
//            reducedStringDim = countElements(reducedString) - subStringDim
//            subStrings.append(reducedString[0..<subStringDim])
//            reducedString = reducedString[(iPos + 1)..<reducedStringDim]
//        }
//        
//        var result = Term.parseOneTerm(subStrings[0])
//        
//        for i in 1..<(subStrings.count) {
//            result = result + Term.parseOneTerm(subStrings[i])
//        }
//        
//        return result
    }
    
}

public prefix func - (term: Term) -> Term {
    return Term(length: term.length * -1, timeUnit: term.timeUnit)
}

public func == (left: Term, right: Term) -> Bool {
    return left.length == right.length && left.timeUnit == right.timeUnit
}

public func != (left: Term, right: Term) -> Bool {
    return !(left == right)
}
    

public func + (term : Term, term2 : Term) -> Term {
    return term.addTerm(term2)
}

public func - (term : Term, term2 : Term) -> Term {
    return term.subTerm(term2)
}


public func += (inout term : Term, term2 : Term) {
    term = term + term2
}

public func -= (inout term : Term, term2 : Term) {
    term = term - term2
}