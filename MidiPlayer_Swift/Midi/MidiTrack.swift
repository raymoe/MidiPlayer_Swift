//
//  MidiTrack.swift
//  MidiPlayer
//
//  Created by zhou on 15/11/21.
//  Copyright (c) 2015年 zhou. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
import Foundation

public struct LyricSymbol
{
    public var startTime:Int = 0
    public var text:String = ""
    public var x:Int = 0
    public var minWidth:Int
    {
        get{
            let widthPerChar:Float = 10.0*2.0/3.0
            var width = Float(text.length) * widthPerChar
            var range = text.rangeOfString("i")
            if (range != nil) {
                width -= widthPerChar/2.0
            }
            range = text.rangeOfString("j")
            if(range != nil) {
                width -= widthPerChar/2.0
            }
            range = text.rangeOfString("l")
            if(range != nil) {
                width -= widthPerChar/2.0
            }
            return Int(width)
        }
    }
    
    public var description:String
    {
        return "Lyric start=\(startTime) x=\(x) text=\(text)"
    }
    
    public init()
    {
        
    }
    
    
}

public struct MidiNote
{
    public var startTime:Int = 0
    public var channel:Int = 0
    public var number:Int = 0
    public var duration:Int = 0
    public var endTime:Int = 0
    public init(startTime:Int,channel:Int,number:Int,duration:Int,endTime:Int )
    {
        self.startTime = startTime
        self.number = number
        self.duration = duration
        self.endTime = endTime
    }
    public init()
    {
        
    }
    public mutating func noteOff(endtime:Int)
    {
        duration = endTime - startTime
    }

    
    public func description() -> String
    {
        return "MidiNote channel=\(channel) number=\(number) start=\(startTime) duration=\(duration)"
    }
}


public struct MidiTrack {
    var  number:Int = 0
    var  instrument:Int = 0
    
    public init(tracknum:Int) {
        
    }
    
    public  func copyWithZone(zone: NSZone) -> AnyObject {
        return ""
    }
}