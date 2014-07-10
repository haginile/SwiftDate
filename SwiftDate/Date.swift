//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//  Date.swift
//  SHSLib
//
//  Created by Helin Gai on 6/17/14.
//  Copyright (c) 2014 Helin Gai. All rights reserved.
//

import Foundation

enum Month : Int {
    case January = 1, February, March, April, May, June, July, August, September, October, November, December
}

enum Weekday : Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

enum RollDay : Int {
    case Zero = 0, One = 1, Two, Three, Four, Five,
    Six, Seven, Eight, Nine, Ten,
    Eleven, Twelve, Thirteen, Fourteen, Fifteen,
    Sixteen, Seventeen, Eighteen, Nineteen, Twenty,
    TwentyOne, TwentyTwo, TwentyThree, TwentyFour, TwentyFive,
    TwentySix, TwentySeven, TwentyEight, TwentyNine, Thirty,
    ThirtyOne
}

class Date {
    
    /** serialNumber corresponds to the numerical representations in Excel
     *  serialNumber of 1 corresponds to 1900-01-01,
     *  serialNumber of 2 corresponds to 1900-01-02, etc.
     *  serialNumber of 0 corresponds to "Null date"
     */
    var serialNumber : Int = 0
    
    
    // look forward to having class variables...
    let doubleDigits = [
    "00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
    "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
    "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
    "30", "31"];
    
    
    /** 
     * Default constructor constructs the "null date", with serial number of 0
     */
    init() {
    }
    
    
    /** 
     *  Initialize a date from a serial number (based on Excel)
     *
     *  @param serialNumber A serial number that corresponds to date representations in Excel
     */
    init(serialNumber : Int) {
        self.serialNumber = serialNumber;
    }
    
    
    /**
     *  Initialize a date by specifying the year, month, and day of month
     *
     *  @param year   The year; must be in the range (1900, 2200)
     *  @param month  The month; must be in the range [1, 12]
     *  @param day    The day of month
     */
    init(year : Int, month : Int, day : Int) {
        assert(year < 2200 && year > 1900, "#Year is out of bound!")
        assert(month < 13 && month > 0, "#Month is out of bound!")
        
        var leap = Date.isLeap(year)
        var len = Date.monthLength(month, leapYear: leap)
        assert(day <= len, "#Day is out of bound!")
        
        var offset = Date.monthOffset(month, leapYear: leap)
        serialNumber = day + offset + Date.yearOffset(year)
    }
    
    
    /**
     *  Initialize a date from a string and the formatting mask
     *
     *  @param string  a date string such as "2014-05-15"
     *  @param format  a formatting mask such as "yyyy-mm-dd"; only '-' and '/' are allowed as delimiters
     */
    init(string : String, format : String = "yyyy-mm-dd") {
        serialNumber = parse(string, format: format).serialNumber
    }
    
    
    /** 
     * generates today's date
     */
    class func today() -> Date {
        var t = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: NSDate.date())
        return Date(year: t.year, month: t.month, day: t.day)
    }
    
    
    /**
    *  The nth weekday in a specific month of a year
    *
    *  @param nth     The nth
    *  @param weekday The desired weekday, such as Weekday.Wednesday
    *  @param month   The month
    *  @param year    The year
    *
    *  @return Date object
    */
    class func nthWeekday(nth : Int, weekday : Weekday, month : Int, year : Int) -> Date {
        var first = Date(year : year, month : month, day : 1).weekday()
        var skip = nth - (weekday.toRaw() >= first.toRaw() ? 1 : 0)
        return Date(year: year, month: month, day: 1 + weekday.toRaw() - first.toRaw() + skip * 7)
    }
    
    
    /**
    *  Return the year of the date
    *
    *  @return an integer corresponding to the year of the date
    */
    func year() -> Int {
        var y = (serialNumber / 365) + 1900
        if (serialNumber <= Date.yearOffset(y)) {
            --y
        }
        return y
    }
    
    
    /**
    *  Returns the day in the year
    *  e.g., for 2014-01-01, this function returns 1
    *
    *  @return an integer corresponding to the day of the date in its year
    */
    func dayOfYear() -> Int {
        return serialNumber - Date.yearOffset(year())
    }
    
    
    /**
    *  Returns the month of the date
    *
    *  @return an integer corresponding to the month of the date
    */
    func month() -> Int {
        var d = dayOfYear()
        var m = d / 30 + 1
        var leap = Date.isLeap(year())
        while (d <= Date.monthOffset(m, leapYear: leap)) {
            --m
        }
        while (d > Date.monthOffset(m + 1, leapYear: leap)) {
            ++m
        }
        return m;
    }
    
    
    /**
    *  Returns the day in month of the date
    *
    *  @return an integer corresponding to the day in month of the date
    */
    func day() -> Int {
        return dayOfYear() - Date.monthOffset(month(), leapYear : Date.isLeap(year()))
    }
    
    func dayOfMonth() -> Int {
        return day()
    }
    
    
    /**
    *  returns the day in week of the date
    *  e.g., for 2014-07-08, returns Weekday.Tuesday
    *
    *  @return the day in week
    */
    func weekday() -> Weekday {
        var w = serialNumber % 7
        return Weekday.fromRaw(w == 0 ? 7 : w)!
    }
    
    
    /**
    *  Returns the last calendar date of the month corresponding to the date
    *  e.g., for 2014-05-15, this function returns 2014-05-31
    *
    *  @param Date the date based on which the last calendar day of the month is determined
    *
    *  @return a date object corresponding to the last calendar day of the month
    */
    class func endOfMonth(date : Date) -> Date {
        var m = date.month()
        var y = date.year()
        return Date(year: y, month: m, day: Date.monthLength(m, leapYear: Date.isLeap(y)))
    }
    
    
    /**
    *  Returns the first calendar date of the month corresponding to the date
    *  e.g., for 2014-05-15, this function returns 2014-05-01
    *
    *  @param Date the date based on which the first calendar day of the month is determined
    *
    *  @return a date object corresponding to the first calendar day of the month
    */
    class func firstDayOfMonth(date : Date) -> Date {
        var m = date.month()
        var y = date.year()
        return Date(year: y, month: m, day: 1)
    }
    
    
    /**
    *  Check whether or not two dates are in the same period, based on a timeUnit
    *  e.g., 
    *     samePeriod(Date("2014-01-05"), date2 : Date("2014-01-15"), timeUnit : TimeUnit.Month) returns true
    *     since the two dates are in the same month
    *
    *  @param date1
    *  @param date2
    *  @param timeUnit Can be TimeUnit.Month, TimeUnit.Year, TimeUnit.Week, or TimeUnit.Day
    *
    *  @return a boolean representing whether or not the two dates are in the same period
    */
    class func samePeriod(date1 : Date, date2 : Date, timeUnit : TimeUnit) -> Bool {
        var result = false
        switch timeUnit {
        case TimeUnit.Month:
            result = date1.month() == date2.month()
        case TimeUnit.Year:
            result = date1.year() == date2.year()
        case TimeUnit.Week:
            var daysFromStartOfWeek : Int = (date1 - (date2 - date2.weekday().toRaw()))
            result = (daysFromStartOfWeek > 0 && daysFromStartOfWeek < 8)
        case TimeUnit.Day:
            result = (date1 == date2)
        default:
            break;
        }
        return result
    }
    
    // increment a date; do NOT use directly
    class func advance(date : Date, length : Int, timeUnit : TimeUnit, var rollDay : RollDay = RollDay.Zero) -> Date {
        switch timeUnit {
        case TimeUnit.Day:
            return Date(serialNumber: date.serialNumber + length)
        case TimeUnit.Week:
            return Date(serialNumber: date.serialNumber + 7 * length)
        case TimeUnit.Month:
            if rollDay == RollDay.Zero {
                rollDay = date.defaultRollDay()
            }
            var d = date.dayOfMonth()
            var m = date.month() + length
            var y = date.year()
            while (m > 12) {
                m -= 12
                y += 1
            }
            while (m < 1) {
                m += 12
                y -= 1
            }
            
            var resultBOM = Date(year: y, month: m, day: 1)
            var result = Date(serialNumber: resultBOM.serialNumber + rollDay.toRaw() - 1)
            if (resultBOM.month() == result.month()) {
                return result
            } else {
                return Date.endOfMonth(resultBOM)
            }
        default:
            return Date()
        }
    }
    
    /**
    *  Add a number of calendar days
    *
    *  @param days number of calendar days to add
    *
    *  @return a new date corresponding to the current date plus days
    */
    func addDays(days : Int) -> Date {
        return Date.advance(self, length: days, timeUnit: TimeUnit.Day)
    }

    /**
    *  Subtract a number of calendar days
    *
    *  @param days number of calendar days to sutrct
    *
    *  @return a new date corresponding to the current date minus days
    */
    func subDays(days : Int) -> Date {
        return Date.advance(self, length: -days, timeUnit: TimeUnit.Day)
    }
    
    /**
    *  The default roll day; used for advancing the current day by X months/years
    *  e.g., for "2014-05-15", the rollday is RollDay.Fifteen
    *
    *  @return the roll day corresponding to the current date
    */
    func defaultRollDay() -> RollDay {
        return RollDay.fromRaw(day())!
    }
    
    /**
    *  Add numberOfMonths to a date
    *
    *  @param numberOfMonths   numberOfMonths to be added
    *  @param rollDay          the roll day; if roll day is RollDay.Zero (default), then the defaultRollDay() will be used
    *                          consider "2014-04-30", adding one month using the default rollday would return "2014-05-30"
    *                          alternatively, you may specify the rollday to be RollDay.ThirtyOne, in which case "2014-05-31"
    *                          will be returned
    *
    *  @return the new date
    */
    func addMonths(var numberOfMonths : Int, var rollDay : RollDay = RollDay.Zero) -> Date {
        return Date.advance(self, length: numberOfMonths, timeUnit: TimeUnit.Month, rollDay : rollDay)
    }
    
    /**
    *  Add numberOfYears to a date
    *
    *  @param numberOfYears   numberOfYears to be added
    *  @param rollDay         the roll day; if roll day is RollDay.Zero (default), then the defaultRollDay() will be used
    *                         see comment on addMonths
    *
    *  @return the new date
    */
    func addYears(numberOfYears : Int, rollDay : RollDay = RollDay.Zero, allowRollToNextMonth : Bool = false) -> Date {
        return addMonths(numberOfYears * 12, rollDay: rollDay)
    }
    
    /**
    *  Add numberOfWeeks to a date
    *
    *  @param numberOfWeeks   numberOfWeeks to add
    *
    *  @return the new date
    */
    func addWeeks(numberOfWeeks : Int) -> Date {
        return Date.advance(self, length: numberOfWeeks, timeUnit: TimeUnit.Week)
    }
    
    /**
    *  Add a term (e.g., Term(string : "6M")) to a date
    *
    *  @param term    term to be added, such as Term(string : "6M")
    *  @param rollDay the roll day; if roll day is RollDay.Zero (default), then the defaultRollDay() will be used
    *                 see comment on addMonths
    *  @param allowRollToNextMonth  can the new date be rolled into the next month?
    *
    *  @return the new date
    */
    func add(term : Term, rollDay : RollDay = RollDay.Zero) -> Date {
        switch (term.timeUnit) {
        case TimeUnit.Month:
            return addMonths(term.length, rollDay: rollDay)
        case TimeUnit.Day:
            return addDays(term.length)
        case TimeUnit.Week:
            return addWeeks(term.length)
        case TimeUnit.Year:
            return addYears(term.length, rollDay: rollDay)
        }
    }
    
    /**
    *  Subtract a term (e.g., Term(string : "6M")) to a date
    *
    *  @param term    term to be subtracted, such as Term(string : "6M")
    *  @param rollDay the roll day; if roll day is RollDay.Zero (default), then the defaultRollDay() will be used
    *                 see comment on addMonths
    *  @param allowRollToNextMonth  can the new date be rolled into the next month?
    *
    *  @return the new date
    */
    func sub(term : Term, rollDay : RollDay = RollDay.Zero) -> Date {
        switch (term.timeUnit) {
        case TimeUnit.Month:
            return addMonths(-term.length, rollDay: rollDay)
        case TimeUnit.Day:
            return addDays(-term.length)
        case TimeUnit.Week:
            return addWeeks(-term.length)
        case TimeUnit.Year:
            return addYears(-term.length, rollDay: rollDay)
        }
    }
    
    /**
    *  Returns a string representation of the date
    *
    *  @param format The formatting mask such as "yyyy-mm-dd"; only "-" & "/" are allowed as delimiters
    *
    *  @return the string representation of the date
    */
    func description(format : String = "yyyy-mm-dd") -> String {
        if serialNumber == 0 {
            return "Null date"
        }
        var flist : [String]
        var d = day(), m = month(), y = year()
        var delim : String
        if format.rangeOfString("/") {
            delim = "/"
        } else {
            delim = "-"
        }
        
        flist = format.componentsSeparatedByString(delim)
        
        var output = String()
        for i in 0..<flist.count {
            var sub = flist[i]
            if sub.lowercaseString == "dd" {
                output += doubleDigits[d]
            } else if sub.lowercaseString == "mm" {
                output += doubleDigits[m]
            } else if sub.lowercaseString == "yyyy" {
                output += y.bridgeToObjectiveC().stringValue
            }
            
            if i != flist.count - 1 {
                output += delim
            }
        }
        return output
    }


    /**
    *  The number of days in a month
    *
    *  @param month
    *  @param leapYear whether or not this is a leap year
    *
    *  @return an integer corresponding to the number of days in the month
    */
    class func monthLength(month : Int, leapYear : Bool) -> Int {
        let MonthLength : [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        let MonthLeapLength : [Int] = [ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
        if leapYear {
            return MonthLeapLength[month - 1]
        } else {
            return MonthLength[month - 1]
        }
    }
    
    
    
    /**
    *  Check whether a year is a leap year
    *
    *  @param year
    *
    *  @return a boolean representing whether or not the year is a leap year
    */
    class func isLeap(year : Int) -> Bool {
        return (year == 1900) || (year % 400 == 0) || ( (year % 4 == 0) && (year % 100 != 0) );
    }

    class func monthOffset(month : Int, leapYear : Bool) -> Int {
        let MonthOffset : [Int] = [
            0,  31,  59,  90, 120, 151,
            181, 212, 243, 273, 304, 334,
            365 ]
        let MonthLeapOffset : [Int] = [
            0,  31,  60,  91, 121, 152,
            182, 213, 244, 274, 305, 335,
            366 ]
        return leapYear ? MonthLeapOffset[month - 1] : MonthOffset[month - 1]
    }
    
    
    class func yearOffset(year : Int) -> Int {
        let YearOffset : [Int] = [
            // 1900-1909
            0,  366,  731, 1096, 1461, 1827, 2192, 2557, 2922, 3288,
            // 1910-1919
            3653, 4018, 4383, 4749, 5114, 5479, 5844, 6210, 6575, 6940,
            // 1920-1929
            7305, 7671, 8036, 8401, 8766, 9132, 9497, 9862,10227,10593,
            // 1930-1939
            10958,11323,11688,12054,12419,12784,13149,13515,13880,14245,
            // 1940-1949
            14610,14976,15341,15706,16071,16437,16802,17167,17532,17898,
            // 1950-1959
            18263,18628,18993,19359,19724,20089,20454,20820,21185,21550,
            // 1960-1969
            21915,22281,22646,23011,23376,23742,24107,24472,24837,25203,
            // 1970-1979
            25568,25933,26298,26664,27029,27394,27759,28125,28490,28855,
            // 1980-1989
            29220,29586,29951,30316,30681,31047,31412,31777,32142,32508,
            // 1990-1999
            32873,33238,33603,33969,34334,34699,35064,35430,35795,36160,
            // 2000-2009
            36525,36891,37256,37621,37986,38352,38717,39082,39447,39813,
            // 2010-2019
            40178,40543,40908,41274,41639,42004,42369,42735,43100,43465,
            // 2020-2029
            43830,44196,44561,44926,45291,45657,46022,46387,46752,47118,
            // 2030-2039
            47483,47848,48213,48579,48944,49309,49674,50040,50405,50770,
            // 2040-2049
            51135,51501,51866,52231,52596,52962,53327,53692,54057,54423,
            // 2050-2059
            54788,55153,55518,55884,56249,56614,56979,57345,57710,58075,
            // 2060-2069
            58440,58806,59171,59536,59901,60267,60632,60997,61362,61728,
            // 2070-2079
            62093,62458,62823,63189,63554,63919,64284,64650,65015,65380,
            // 2080-2089
            65745,66111,66476,66841,67206,67572,67937,68302,68667,69033,
            // 2090-2099
            69398,69763,70128,70494,70859,71224,71589,71955,72320,72685,
            // 2100-2109
            73050,73415,73780,74145,74510,74876,75241,75606,75971,76337,
            // 2110-2119
            76702,77067,77432,77798,78163,78528,78893,79259,79624,79989,
            // 2120-2129
            80354,80720,81085,81450,81815,82181,82546,82911,83276,83642,
            // 2130-2139
            84007,84372,84737,85103,85468,85833,86198,86564,86929,87294,
            // 2140-2149
            87659,88025,88390,88755,89120,89486,89851,90216,90581,90947,
            // 2150-2159
            91312,91677,92042,92408,92773,93138,93503,93869,94234,94599,
            // 2160-2169
            94964,95330,95695,96060,96425,96791,97156,97521,97886,98252,
            // 2170-2179
            98617,98982,99347,99713,100078,100443,100808,101174,101539,101904,
            // 2180-2189
            102269,102635,103000,103365,103730,104096,104461,104826,105191,105557,
            // 2190-2199
            105922,106287,106652,107018,107383,107748,108113,108479,108844,109209,
            // 2200
            109574,
            // 2201-2209
            109939,110304,110669,111034,111400,111765,112130,112495,112861,
            // 2210-2219
            113226,113591,113956,114322,114687,115052,115417,115783,116148,116513,
            // 2220-2229
            116878,117244,117609,117974,118339,118705,119070,119435,119800,120166,
            // 2230-2239
            120531,120896,121261,121627,121992,122357,122722,123088,123453,123818,
            // 2240-2249
            124183,124549,124914,125279,125644,126010,126375,126740,127105,127471,
            // 2250-2259
            127836,128201,128566,128932,129297,129662,130027,130393,130758,131123,
            // 2260-2269
            131488,131854,132219,132584,132949,133315,133680,134045,134410,134776,
            // 2270-2279
            135141,135506,135871,136237,136602,136967,137332,137698,138063,138428,
            // 2280-2289
            138793,139159,139524,139889,140254,140620,140985,141350,141715,142081,
            // 2290-2300
            142446,142811,143176,143542,143907,144272,144637,145003,145368,145733,
            146098]
        return YearOffset[year-1900];
    }
    
        
    func parse(string : String, format : String = "yyyy-mm-dd") -> Date {
        var slist : [String]
        var flist : [String]
        
        var d : Int = 0
        var m : Int = 0
        var y : Int = 0
        
        var delim : String
        
        if string.rangeOfString("/") {
            delim = "/"
        } else {
            delim = "-"
        }
        
        slist = string.componentsSeparatedByString(delim)
        flist = format.componentsSeparatedByString(delim)
        
        assert(slist.count == flist.count, "#String does not match format mask!")
        
        for i in 0..<flist.count {
            var sub = flist[i]
            if sub.lowercaseString == "dd" {
                d = slist[i].toInt()!
            } else if sub.lowercaseString == "mm" {
                m = slist[i].toInt()!
            } else if sub.lowercaseString == "yyyy" {
                y = slist[i].toInt()!
            }
        }
        if y < 100 {
            y += 2000
        }
        return Date(year: y, month: m, day: d)
    }
}

@infix func == (left: Date, right: Date) -> Bool {
    return left.serialNumber == right.serialNumber
}

@infix func != (left: Date, right: Date) -> Bool {
    return left.serialNumber != right.serialNumber
}


@infix func < (left: Date, right: Date) -> Bool {
    return left.serialNumber < right.serialNumber
}

@infix func <= (left: Date, right: Date) -> Bool {
    return left.serialNumber <= right.serialNumber
}

@infix func > (left: Date, right: Date) -> Bool {
    return left.serialNumber > right.serialNumber
}

@infix func >= (left: Date, right: Date) -> Bool {
    return left.serialNumber >= right.serialNumber
}

@infix func + (date : Date, days : Int) -> Date {
    return date.addDays(days)
}

@infix func + (date : Date, string : String) -> Date {
    return date.add(Term(string: string))
}

@infix func - (date : Date, days : Int) -> Date {
    return date.subDays(days)
}

@infix func - (date1 : Date, date2 : Date) -> Int {
    return date1.serialNumber - date2.serialNumber
}


@assignment func += (inout date : Date, days : Int) {
    date = date + days
}

@assignment func -= (inout date : Date, days : Int) {
    date = date - days
}

