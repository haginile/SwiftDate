//
//  SwiftDateTests.swift
//  SwiftDateTests
//
//  Created by Helin Gai on 7/8/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

//
//  SwiftDateTests.swift
//  SwiftDateTests
//
//  Created by Helin Gai on 7/8/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import XCTest
import SwiftDate

class SwiftDateTesting: XCTestCase {
    func testDate() {
        XCTAssert(Date.isLeap(2000) == true, "Pass")
        XCTAssert(Date.isLeap(2001) == false, "Pass")
        
        var date1 = Date(year: 2014, month: 5, day: 15)
        XCTAssertEqual(date1.serialNumber, 41774, "Pass")
        XCTAssertEqual(date1.description(), "2014-05-15", "Pass")
        XCTAssertEqual(date1.year(), 2014, "Pass")
        XCTAssertEqual(date1.month(), 5, "Pass")
        XCTAssertEqual(date1.day(), 15, "Pass")
        XCTAssertEqual(date1.dayOfYear(), 135, "Pass")
        XCTAssertEqual(Date(string: "2014-01-01").dayOfYear(), 1, "Pass")
        XCTAssertEqual(date1.weekday(), Weekday.Thursday, "Pass")
        XCTAssertEqual(Date.endOfMonth(date1).serialNumber, Date(string : "2014-05-31").serialNumber, "Pass")
        XCTAssertEqual(Date.firstDayOfMonth(date1).serialNumber, Date(string : "2014-05-01").serialNumber, "Pass")
        
        XCTAssertEqual(Date(string : "2014-04-30").addMonths(1).serialNumber, Date(string : "2014-05-30").serialNumber, "Pass")
        XCTAssertEqual(Date(string : "2014-04-30").addMonths(1, rollDay: RollDay.ThirtyOne).serialNumber, Date(string : "2014-05-31").serialNumber, "Pass")
        
        var date2 = Date(string: "2014-05-15", format: "yyyy-mm-dd")
        XCTAssertEqual(date2.serialNumber, 41774, "Pass")
        
    }
    
    func testTerm() {
        var td = Term(string : "7D")
        XCTAssertEqual(td.dayCountFraction(), 7.0 / 365.242, "Pass")
        
        var tm = Term(string: "3M")
        XCTAssertEqual(tm.dayCountFraction(), 0.25, "Pass")
        
        var sumtm = Term(string : "3M") + Term(string: "1Y")
        XCTAssertEqual(sumtm.dayCountFraction(), 1.25, "Pass")
        XCTAssertEqual(sumtm.description(), "15M", "Pass")
    }
    
    func testCalendar() {
        var cal = USSettlementCalendar()
        XCTAssert(cal.isBizDay(Date(string: "2014-05-15")) == true, "Pass")
        XCTAssert(cal.isBizDay(Date(string: "2014-05-17")) == false, "Pass")
        XCTAssertEqual(cal.nextBizDay(Date(string: "2014-05-16")).serialNumber, Date(string: "2014-05-19").serialNumber, "Pass")
        XCTAssertEqual(cal.bizDaysBetween(Date(string: "2014-05-15"), toDate: Date(string : "2014-05-20")), 3, "Pass")
    }
    
    func testDayCounter() {
        
    }
}
