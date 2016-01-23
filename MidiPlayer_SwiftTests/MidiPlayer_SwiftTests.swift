//
//  MidiPlayer_SwiftTests.swift
//  MidiPlayer_SwiftTests
//
//  Created by zhou on 15/11/22.
//  Copyright © 2015年 zhou. All rights reserved.
//

import XCTest
import MoeMidi
@testable import MidiPlayer_Swift

class MidiPlayer_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testArray() {
        let start = CFAbsoluteTimeGetCurrent()
        let m = 100000000
        var list : [Int] = [Int](count: m, repeatedValue: 0)
        for i in 1...m-1
        {
            list[i] = i
        }
        let t1 = CFAbsoluteTimeGetCurrent()
        list.insert(0, atIndex: m/2)
        print(CFAbsoluteTimeGetCurrent()-t1)
        print(CFAbsoluteTimeGetCurrent()-start)
    }
    
    func testNSData()
    {
        let data:NSData? = NSData(contentsOfFile:"/Users/zhou/work/music/adele-chasing_pavements.mid")
        print(data?.length)
    }
    
    func testInOut()
    {
        let event : MidiEvent = MidiEvent()
        var events = [event]
        modifyMidiEvent(events)
        print(event.controlValue)
    }
    
    func modifyMidiEvent(var ev:[MidiEvent])
    {
        ev[0].controlValue = 20
        let event : MidiEvent = MidiEvent()
        ev.append(event)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testIO()
    {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
    }
    
}
