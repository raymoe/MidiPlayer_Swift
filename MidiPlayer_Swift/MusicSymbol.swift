//
//  MidiSymbol.swift
//  MidiPlayer_Swift
//
//  Created by zhou on 15/11/22.
//  Copyright © 2015年 zhou. All rights reserved.
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

protocol MusicSymbol
{
    var startTime : Int{ get set }
    var minWidth : Int { get set }
    var width : Int { get set }
    var aboveStaff : Int { get set }
    var belowStaff : Int { get set }
    
    //func draw(ytop:Int)
}

//public class AccidSymbol : MusicSymbol {
//    var accid : Int
//    var whiteNote : WhiteNote
//    var clef : Int
//    var width : Int
//    
//    var minWidth : Int {
//        //return 3*
//    }
//    
//    public init(accid:Int,note:WhiteNote,clef:Int){
//        self.accid = accid
//        self.whiteNote = note
//        self.clef = clef
//        
//    }
//    
//    public func drawSharp(ynote:Int){
//        
//    }
//    
//    public func drawFlat(ynote: Int) {
//        
//    }
//    
//    public func drawNatural(ynote:Int){
//        
//    }
//}

//public class ChordSymbol : MusicSymbol
//{
//    public var clef : Int
//    
//    public var endTime : Int
//    
//    public var hasTwoStems : Bool
//    
//    
//    
//}
