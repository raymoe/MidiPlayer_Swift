//
//  MidiFile.swift
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
import Darwin

public enum NoteDuration : Int
{
    case ThirtySecond = 0
    case Sixteenth
    case Triplet
    case Eighth
    case DottedEighth
    case Quarter
    case DottedQuarter
    case Half
    case DottedHalf
    case Whole
}


//let ThirtySecond     = 0
//let Sixteenth        = 1
//let Triplet          = 2
//let Eighth           = 3
//let DottedEighth     = 4
//let Quarter          = 5
//let DottedQuarter    = 6
//let Half             = 7
//let DottedHalf       = 8
//let Whole            = 9

let NoteScale_A       = 0
let NoteScale_Asharp  = 1
let NoteScale_Bflat   = 1
let NoteScale_B       = 2
let NoteScale_C       = 3
let NoteScale_Csharp  = 4
let NoteScale_Dflat   = 4
let NoteScale_D       = 5
let NoteScale_Dsharp  = 6
let NoteScale_Eflat   = 6
let NoteScale_E       = 7
let NoteScale_F       = 8
let NoteScale_Fsharp  = 9
let NoteScale_Gflat   = 9
let NoteScale_G       = 10
let NoteScale_Gsharp  = 11
let NoteScale_Aflat   = 11



let WhiteNote_A  = 0
let WhiteNote_B  = 1
let WhiteNote_C  = 2
let WhiteNote_D  = 3
let WhiteNote_E  = 4
let WhiteNote_F  = 5
let WhiteNote_G  = 6

let Clef_Treble = 0
let Clef_Bass   = 1

func notescale_to_number(notescale:Int,octave:Int) -> Int
{
    return 9 + notescale + octave * 12
}

func notescale_from_number(number:Int) -> Int
{
    return (number + 3) % 12
}

func notescale_is_black_key(notescale:Int) -> Bool
{
    if( notescale == NoteScale_Asharp ||
        notescale == NoteScale_Csharp ||
        notescale == NoteScale_Dsharp ||
        notescale == NoteScale_Fsharp ||
        notescale == NoteScale_Gsharp){
            return true
    }
    else{
        return false
    }
    //if notescale in
//    switch notescale
//    {
//    case NoteScale_Asharp:
//    case NoteScale_Csharp:
//    case NoteScale_Dsharp:
//    case NoteScale_Fsharp:
//    case NoteScale_Gsharp:
//        return true
//    
//    }
}
public class WhiteNote
{
    public static var _topTreble:WhiteNote? = nil
    public static var _topBass : WhiteNote? = nil
    public static var _bottomTreble : WhiteNote? = nil
    public static var _bottomBass : WhiteNote? = nil
    public static var _middleC : WhiteNote? = nil
    
    public var letter : Int
    
    public var octave : Int
    
    public init(letter:Int,octave:Int) {
        self.letter = letter
        self.octave = octave
        assert(letter>=0 && letter<=6)
    }
    
    public func dist(w:WhiteNote) -> Int {
        return (octave - w.octave)*7 + (letter - w.letter)
    }
    
    public func add(amount:Int) -> WhiteNote {
        var num = octave * 7 + letter
        num += amount
        if(num < 0){
            num = 0
        }
        return WhiteNote.create(num%7, octave: num/7)
    }
    
    public var number:Int {
        var offset = 0
        switch(letter){
        case WhiteNote_A: offset = NoteScale_A; break
        case WhiteNote_B: offset = NoteScale_B; break
        case WhiteNote_C: offset = NoteScale_C; break
        case WhiteNote_D: offset = NoteScale_D; break
        case WhiteNote_E: offset = NoteScale_E; break
        case WhiteNote_F: offset = NoteScale_F; break
        case WhiteNote_G: offset = NoteScale_G; break
        default: offset = 0; break
        }
        return notescale_to_number(offset, octave: octave);
    }
    
    public static func create(letter:Int,octave:Int)-> WhiteNote{
        let w : WhiteNote = WhiteNote(letter: letter, octave: octave)
        return w
    }
    
    public static var topTreble:WhiteNote {
        if _topTreble == nil {
            _topTreble = WhiteNote.create(WhiteNote_E, octave: 5)
        }
        return _topTreble!
    }
    
    public static var bottomTreble:WhiteNote {
        if _bottomTreble == nil {
            _bottomTreble = WhiteNote.create(WhiteNote_F, octave: 4)
        }
        return _bottomTreble!
    }
    
    public static var topBass:WhiteNote {
        if _topBass == nil {
            _topBass = WhiteNote.create(WhiteNote_G, octave: 3)
        }
        return _topBass!
    }
    
    public static var bottomBass:WhiteNote {
        if _bottomBass == nil {
            _bottomBass = WhiteNote.create(WhiteNote_A, octave: 3)
        }
        return _bottomBass!
    }
    
    public static var middleC:WhiteNote {
        if _middleC == nil {
            _middleC = WhiteNote.create(WhiteNote_C, octave: 4)
        }
        return _middleC!
    }
    
    public static func top(clef:Int)->WhiteNote {
        if clef == Clef_Treble {
            return WhiteNote.topTreble
        }
        else {
            return WhiteNote.topBass
        }
    }
    
    public static func bottom(clef:Int)->WhiteNote {
        if clef == Clef_Treble {
            return WhiteNote.bottomTreble
        }
        else {
            return WhiteNote.bottomBass
        }
    }
    
    public static func compare(x:WhiteNote,y:WhiteNote) -> Int{
        return x.dist(y)
    }
    
    public static func min(x:WhiteNote,y:WhiteNote) -> WhiteNote{
        if x.dist(y) < 0 {
            return x
        }
        else {
            return y
        }
    }
    
}

let StemUp = 1
let StemDown = 2
let LeftSide = 1
let RightSide = 2


public class Stem
{
    public var duration : NoteDuration
    
    public var direction : Int
    
    public var top : WhiteNote
    
    public var bottom : WhiteNote
    
    public var end : WhiteNote?
    
    public var notesoverlap : Bool
    
    public var side : Int
    public var pair : Stem?
    public var width_to_pair : Int
    
    public var receiver : Bool
    
    public init(bottom:WhiteNote,top:WhiteNote,dur:Int,dir:Int,overlap:Bool) {
        self.top = top
        self.bottom = bottom
        duration = NoteDuration.init(rawValue: dir)!
        direction = dir
        notesoverlap = overlap
        
        if (direction == StemUp || overlap) {
            side = RightSide
        }
        else {
            side = LeftSide
        }
        pair = nil
        width_to_pair = 0
        receiver = false
        self.end = self.calculateEnd()
    }
    
    public func calculateEnd() -> WhiteNote? {
        if direction == StemUp {
            var w = top.add(6)
            if (duration == NoteDuration.Sixteenth) {
                w = w.add(2)
            }
            else if (duration == NoteDuration.ThirtySecond) {
                w = w.add(4)
            }
            return w
        }
        else if (direction == StemDown) {
            var w = bottom.add(-6)
            if(duration == NoteDuration.Sixteenth){
                w = w.add(-2)
            }
            else if(duration == NoteDuration.ThirtySecond){
                w = w.add(-4)
            }
            return w;
        }
        else {
            return nil
        }
    }
}


//func enventName(ev:Int)->

//func varlenToBytes(num:Int,CUnsignedChar[]
//public class MidiFileReader
//{
//    public init(fileName:String){
//        
//    }
//}
//
//public class MidiFile
//{
//    public init(path:String){
//        let  name = path.cStringUsingEncoding(NSUTF8StringEncoding)
//        var fd = open(name!, O_RDONLY)
//        if fd == -1{
//            
//        }
//        struct stat info;
//        stat(name,&info)
//    }
//}