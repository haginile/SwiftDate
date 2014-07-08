SwiftDate
=========

SwiftDate is a flexible and powerful Date/Calendar library written completely in Swift. It is based on QuantLib, the popular quantitative finance library, and is designed to be very friendly to financial applications. Even if you are not building financial applications, you may still find its date shifting and calendar classes useful.

Getting Started
===============

Date
----

The Date class allows you to work with calendar days efficiently.

Creating a date is simple:

    var d1 = Date(year : 2014, month : 5, day : 15)
    var d2 = Date(string : "2014-05-15")

Simple date math works as expected:

    d1 = d1 + 1
    if (d2 > d1) {
        ...
    }

But there are more sophisticated date shifting functions:

    var d = Date(string : "2014-04-30")
    d.addMonths(1)                                  // returns "2014-05-30"
    d.addMonths(1, rollDay : RollDay.ThirtyOne)     // returns "2014-05-31"
    d.add(Term(string : "1M"))                      // returns "2014-05-30"


Calendar
--------

The Swift Calendar class allows you to check work with different calendars, such as the NYSE calendar. Try this:

    var cal = USNYSECalendar()
    var d1 = Date(string : "2014-07-03")
    var nbd = cal.nextBizDay(d1)   // returns "2014-07-07" - skipped over 4th of July!


Day Counter
-----------

The DayCounter class lets you compute the year fraction (day count fraction) between two dates using the Actual/Actual, Actual/360, Actual/365, NL/365, and 30/360 conventions. It works like this:

    var dc = Actual360()
    dc.dayCountFraction(Date(string : "2014-01-31"), date2: Date(string : "2014-02-28")) // returns 28.0 / 360.0


Community
==========

Check out this [online forum](http://swift.versify-app.com) for the latest updates.


Copyright and license
=====================

Code and documentation copyright 2014 SHFuse. Code is released under the MIT license.