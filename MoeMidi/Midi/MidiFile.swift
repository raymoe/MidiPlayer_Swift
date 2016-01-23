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
import MoeBase



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

func varlenToBytes(num:Int,buf:UnsafeMutablePointer<u_char>,offset:Int) -> Int
{
    let b1 = (u_char) ((num >> 21) & 0x7F);
    let b2 = (u_char) ((num >> 14) & 0x7F);
    let b3 = (u_char) ((num >>  7) & 0x7F);
    let b4 = (u_char) (num & 0x7F);
    
    if (b1 > 0) {
        buf[offset]   = (u_char)(b1 | 0x80);
        buf[offset+1] = (u_char)(b2 | 0x80);
        buf[offset+2] = (u_char)(b3 | 0x80);
        buf[offset+3] = b4;
        return 4;
    }
    else if (b2 > 0) {
        buf[offset]   = (u_char)(b2 | 0x80);
        buf[offset+1] = (u_char)(b3 | 0x80);
        buf[offset+2] = b4;
        return 3;
    }
    else if (b3 > 0) {
        buf[offset]   = (u_char)(b3 | 0x80);
        buf[offset+1] = b4;
        return 2;
    }
    else {
        buf[offset] = b4;
        return 1;
    }
}

func intToBytes(value:Int,buf:UnsafeMutablePointer<u_char>,offset:Int)
{
    buf[offset] = (u_char)( (value >> 24) & 0xFF );
    buf[offset+1] = (u_char)( (value >> 16) & 0xFF );
    buf[offset+2] = (u_char)( (value >> 8) & 0xFF );
    buf[offset+3] = (u_char)( value & 0xFF );
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

public class TimeSignature {
    public var numerator : Int = 0      /** Numerator of the time signature */
    public var denominator : Int = 0    /** Denominator of the time signature */
    public var quarter : Int = 0        /** Number of pulses per quarter note */
    public var measure : Int = 0        /** Number of pulses per measure */
    public var tempo : Int = 0          /** Number of microseconds per quarter note */
    
    public init(numerator:Int,denominator:Int,quarter:Int,tempo:Int) throws{
        var beat = 0
        if(numerator <= 0 || denominator <= 0 || quarter <= 0)
        {
            ErrorHandler.error("Invalid Time Signature", offset: 0)
            throw MidiFileError.Error
        }
        self.numerator = numerator
        self.denominator = denominator
        self.quarter = quarter
        self.tempo = tempo
        
        if(self.numerator == 5){
            self.numerator = 4
        }
        if(self.denominator < 4)
        {
            beat = self.quarter * 2;
        }
        else
        {
            beat = self.quarter/(self.denominator/4)
        }
        measure = self.numerator * beat
    }
    
    public func getNoteDuration(duration:Int) -> NoteDuration{
        let whole = quarter * 4
        
        /**
        1       = 32/32
        3/4     = 24/32
        1/2     = 16/32
        3/8     = 12/32
        1/4     =  8/32
        3/16    =  6/32
        1/8     =  4/32 =    8/64
        triplet         = 5.33/64
        1/16    =  2/32 =    4/64
        1/32    =  1/32 =    2/64
        **/
        
        if(duration >= 28*whole/32) {
            return NoteDuration.Whole
        }
        else if(duration >= 20*whole/32) {
            return NoteDuration.DottedHalf
        }
        else if (duration >= 14*whole/32){
            return NoteDuration.Half
        }
        else if (duration >= 10*whole/32){
            return NoteDuration.DottedQuarter
        }
        else if (duration >=  7*whole/32) {
            return NoteDuration.Quarter
        }
        else if (duration >=  5*whole/32) {
            return NoteDuration.DottedEighth
        }
        else if (duration >=  6*whole/64) {
            return NoteDuration.Eighth
        }
        else if (duration >=  5*whole/64) {
            return NoteDuration.Triplet
        }
        else if (duration >=  3*whole/64) {
            return NoteDuration.Sixteenth
        }
        else{
            return NoteDuration.ThirtySecond
        }
    }
    
    
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

public class MidiNote
{
    public var startTime:Int = 0
    public var channel:UInt8 = 0
    public var number:UInt8 = 0
    public var duration:Int = 0
    public var endTime:Int = 0
    public init(startTime:Int,channel:UInt8,number:UInt8,duration:Int,endTime:Int )
    {
        self.startTime = startTime
        self.number = number
        self.duration = duration
        self.endTime = endTime
    }
    
    public init(event:MidiEvent)
    {
        startTime = event.startTime
        number = event.noteNumber
        channel = event.channel
    }
    
    public init()
    {
        
    }
    
    public init(note:MidiNote)
    {
        startTime = note.startTime
        number = note.number
        duration = note.duration
        endTime = note.endTime
    }
    
    public func noteOff(endtime:Int)
    {
        duration = endTime - startTime
    }
    
    
    public func description() -> String
    {
        return "MidiNote channel=\(channel) number=\(number) start=\(startTime) duration=\(duration)"
    }
}


public class MidiTrack {
    var  number:Int = 0
    var  instrument:UInt8 = 0
    var  notes : [MidiNote]?
    var  lyrics : [MidiEvent]?
    public init(tracknum:Int) {
        number = tracknum
        notes = [MidiNote]()
        instrument = 0
    }
    
    public init(track:MidiTrack){
        //self.init(tracknum : track.number)
        number = track.number;
        instrument = track.instrument
        if(track.notes != nil){
            notes = [MidiNote]()
            for note in track.notes!{
                let noteCopy = MidiNote(note: note)
                notes!.append(noteCopy)
            }
        }
        
        if(track.lyrics != nil) {
            lyrics = [MidiEvent]()
            for lyric in track.lyrics!{
                lyrics!.append(lyric)
            }
        }
    }
    
    public init(events:[MidiEvent],tracknum:Int)
    {
        number = tracknum
        notes = [MidiNote]()
        instrument = 0
        for mevent in events {
            if(mevent.eventFlag == EventNoteOn && mevent.velocity > 0){
                let note = MidiNote(event: mevent)
                self.addNote(note)
            }
            else if(mevent.eventFlag == EventNoteOn && mevent.velocity == 0){
                self.noteOff(mevent.channel, num: mevent.noteNumber, endTime: mevent.startTime)
            }
            else if(mevent.eventFlag == EventProgramChange){
                instrument = mevent.instrument
            }
            else if(mevent.eventFlag == MetaEventLyric){
                self.addLyric(mevent)
            }
        }
        if(notes!.count > 0 && notes![0].channel==9){
            instrument = 128;
        }
    }
    
    public func addNote(note:MidiNote){
        notes!.append(note)
    }
    
    public func addLyric(mevent:MidiEvent){
        if(lyrics==nil){
            lyrics = [MidiEvent]()
        }
        lyrics!.append(mevent)
    }
    
    public func noteOff(channel:UInt8,num:UInt8,endTime:Int){
        for(var i=notes!.count-1; i>=0; i--){
            let note : MidiNote = notes![i]
            if(note.channel == channel && note.number == num && note.duration == 0){
                note.noteOff(endTime)
                return;
            }
        }
    }
    
    public  func copyWithZone(zone: NSZone) -> AnyObject {
        return ""
    }
    
    public func description()->String{
        var s = "Track number=\(number) instrument=\(instrument)"
        for note in notes!{
            s.appendContentsOf(note.description())
            s.appendContentsOf("\n")
        }
        s.appendContentsOf("End Track\n")
        return s
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

let EventNoteOff        : UInt8 = 0x80
let EventNoteOn         : UInt8 = 0x90
let EventKeyPressure    : UInt8 = 0xA0
let EventControlChange  : UInt8 = 0xB0
let EventProgramChange  : UInt8 = 0xC0
let EventChannelPressure: UInt8 = 0xD0
let EventPitchBend      : UInt8 = 0xE0
let SysexEvent1         : UInt8 = 0xF0
let SysexEvent2         : UInt8 = 0xF7
let MetaEvent           : UInt8 = 0xFF

let MetaEventSequence   : UInt8 = 0x0
let MetaEventText       : UInt8 = 0x1
let MetaEventCopyright  : UInt8 = 0x2
let MetaEventSequenceName : UInt8 = 0x3
let MetaEventInstrument  : UInt8 = 0x4
let MetaEventLyric       : UInt8 = 0x5
let MetaEventMarker      : UInt8 = 0x6
let MetaEventEndOfTrack  : UInt8 = 0x2F
let MetaEventTempo       : UInt8 = 0x51
let MetaEventSMPTEOffset : UInt8 = 0x54
let MetaEventTimeSignature : UInt8 = 0x58
let MetaEventKeySignature : UInt8  = 0x59



public class MidiFile
{
    
    public var fileName : String
    public var tracks : [MidiTrack]
    
    private var _trackPerChannel:Bool = false
    private var _trackMode : u_short = 0
    private var _quarternote : u_short = 0
    private var _totalpulses : Int = 0
    private var _events : [[MidiEvent]]
    private var _time : TimeSignature? = nil
    public init (path:String) throws{
        //UnsafeMutablePointer<UInt8>
        fileName = path
        tracks = [MidiTrack]()
        _trackPerChannel = false
        _events = [[MidiEvent]]()
        let file : MidiFileReader = try MidiFileReader(path: NSURL(fileURLWithPath: path))
        let hdr = try file.readAscii(4)
        if(strncmp(hdr, "MThd", 4) != 0){
            ErrorHandler.error("Bad MThd header", offset: 0)
            throw MidiFileError.Error
        }
        let len = try file.readInt();
        if(len != 6){
            ErrorHandler.error("Bad MThd len", offset: 4)
            throw MidiFileError.Error
        }
        _trackMode = try file.readShort()
        let num_tracks = try file.readShort()
        _quarternote = try file.readShort()
        
        for (var tracknum = 0; tracknum < Int(num_tracks); tracknum++)
        {
            let trackEvents = try readTrack(file)
            let track = MidiTrack(events: trackEvents, tracknum: tracknum)
            _events.append(trackEvents)
            track.number = tracknum
            if(track.notes!.count>0){
                tracks.append(track)
            }
        }
        for(var tracknum = 0;tracknum<tracks.count;tracknum++){
            let track = tracks[tracknum]
            let last = track.notes![track.notes!.count-1]
            //?
            if(_totalpulses < last.startTime + last.duration){
               _totalpulses = last.startTime + last.duration
            }
        }
        
        if(tracks.count == 1 && MidiFile.hasMultipleChannels(tracks[0])){
            let track = tracks[0]
            let trackevents = _events[track.number]
            let newtracks = MidiFile.splitChannels(track, events: trackevents)
            _trackPerChannel = true
            tracks = newtracks
        }
        MidiFile.checkStartTimes(tracks)
        var tempo = 0
        var numer : UInt8 = 0
        var denom : UInt8 = 0
        for(var tracknum = 0; tracknum < _events.count; tracknum++){
            let eventlist = _events[tracknum]
            for(var i = 0; i < eventlist.count; i++){
                let mevent = eventlist[i]
                if(mevent.metaEvent == MetaEventTempo && tempo == 0){
                    tempo = mevent.tempo
                }
                if(mevent.metaEvent == MetaEventTimeSignature && numer == 0){
                    numer = mevent.numerator;
                    denom = mevent.denominator
                }
            }
        }
        // ?
        if(tempo == 0)
        {
            tempo = 500000
        }
        if(numer == 0)
        {
            numer = 4; denom = 4
        }
        _time = try TimeSignature(numerator: Int(numer), denominator: Int(denom), quarter: Int(_quarternote), tempo: tempo)
    }
    
    public func readTrack(file:MidiFileReader) throws->[MidiEvent]
    {
        var result = [MidiEvent]()
        var starttime = 0
        
        let hdr = try file.readAscii(4)
        if(strncmp(hdr, "MTrk", 4) != 0){
            //throw MidiFileException("Bad MThd header", offset: 0)
            ErrorHandler.error("Bad MTrk header", offset: file.offset - 4)
            throw MidiFileError.Error
        }
        let tracklen = try file.readInt()
        let trackend = tracklen + file.offset
        var eventflag : u_char = 0
        
        while(file.offset < trackend) {
            //var startoffset = 0
            var deltatime = 0
            var peekevent:u_char = 0
            do{
                //startoffset = file.offset
                deltatime =  try file.readVarlen()
                starttime += deltatime
                peekevent = try file.peek()
            }
            catch MidiFileError.FileIsTruncated
            {
                return result
            }
            
            let mevent = MidiEvent()
            mevent.deltaTime = deltatime
            mevent.startTime = starttime
            result.append(mevent)
            
            if(peekevent >= EventNoteOff){
                mevent.hasEventFlag = true
                eventflag = try file.readByte()
            }
            
            if(eventflag >= EventNoteOn && eventflag < EventNoteOn + 16){
                mevent.eventFlag = EventNoteOn
                mevent.channel = eventflag - EventNoteOn
                mevent.noteNumber = try file.readByte()
                mevent.velocity = try file.readByte()
            }
            else if(eventflag >= EventNoteOff && eventflag < EventNoteOff+16){
                mevent.eventFlag = EventNoteOff
                mevent.channel = eventflag - EventNoteOff
                mevent.noteNumber = try file.readByte()
                mevent.velocity = try file.readByte()
            }
            else if(eventflag >= EventKeyPressure && eventflag < EventKeyPressure+16){
                mevent.eventFlag = EventKeyPressure
                mevent.channel = eventflag - EventKeyPressure
                mevent.noteNumber = try file.readByte()
                mevent.keyPressure = try file.readByte()
            }
            else if (eventflag >= EventControlChange &&
                eventflag < EventControlChange + 16) {
                    mevent.eventFlag = EventControlChange;
                    mevent.channel = (u_char)(eventflag - EventControlChange);
                    mevent.controlNum = try file.readByte()
                    mevent.controlValue = try file.readByte()
            }
            else if (eventflag >= EventProgramChange &&
                eventflag < EventProgramChange + 16) {
                    mevent.eventFlag = EventProgramChange;
                    mevent.channel = (u_char)(eventflag - EventProgramChange);
                    mevent.instrument = try file.readByte()
                    
            }
            else if (eventflag >= EventChannelPressure &&
                eventflag < EventChannelPressure + 16) {
                    mevent.eventFlag = EventChannelPressure
                    mevent.channel = (u_char)(eventflag - EventChannelPressure)
                    mevent.chanPressure = try file.readByte()
            }
            else if (eventflag >= EventPitchBend &&
                eventflag < EventPitchBend + 16) {
                    mevent.eventFlag = EventPitchBend;
                    mevent.channel = (u_char)(eventflag - EventPitchBend);
                    mevent.pitchBend = try file.readShort()
            }
            else if (eventflag == SysexEvent1) {
                mevent.eventFlag = SysexEvent1;
                mevent.metalength = try file.readVarlen();
                mevent.metavalue = try file.readBytes(mevent.metalength)
            }
            else if (eventflag == SysexEvent2) {
                mevent.eventFlag = SysexEvent2;
                mevent.metalength = try file.readVarlen();
                mevent.metavalue = try file.readBytes(mevent.metalength)
            }
            else if (eventflag == MetaEvent) {
                mevent.eventFlag = MetaEvent;
                mevent.metaEvent = try file.readByte()
                mevent.metalength = try file.readVarlen()
                mevent.metavalue = try file.readBytes(mevent.metalength)
                
                if (mevent.metaEvent == MetaEventTimeSignature) {
                    if (mevent.metalength < 2) {
//                        MidiFileException *e =
//                            [MidiFileException init:@"Bad Meta Event Time Signature len"
//                        offset:[file offset]];
//                        @throw e;
                    }
                    else if (mevent.metalength >= 2 && mevent.metalength < 4) {
                        mevent.numerator = mevent.metavalue[0] ;
                        let log2 = mevent.metavalue[1];
                        mevent.denominator = u_char(pow(2.0, Double(log2)))
                    }
                    else {
                        mevent.numerator = mevent.metavalue[0] ;
                        let log2 = mevent.metavalue[1];
                        mevent.denominator = u_char(pow(2.0, Double(log2)))
                    }
                }
                else if (mevent.metaEvent == MetaEventTempo) {
                    if (mevent.metalength != 3) {
                        ErrorHandler.error("Bad Meta Event Tempo len", offset: file.offset)
                        throw MidiFileError.Error
                    }
                    let value = mevent.metavalue;
                    mevent.tempo = (Int(value[0]) << 16 | Int(value[1]) << 8 | Int(value[2]));
                }
                else if (mevent.metaEvent == MetaEventEndOfTrack) {
                    //[mevent release];
                    break; 
                }
            }
            else {
                ErrorHandler.error("Unknow event", offset: file.offset - 4);
                throw MidiFileError.Error
            }
            
        }
        return result
    }
    
    public static func hasMultipleChannels(track:MidiTrack) -> Bool
    {
        var notes = track.notes!
        var note = notes[0]
        let channel = note.channel
        for(var i = 0; i < notes.count; i++){
            note = notes[i]
            if(note.channel != channel)
            {
                return true
            }
        }
        return false
    }
    
    public static func splitChannels(origtrack:MidiTrack,events:[MidiEvent]) -> [MidiTrack]
    {
        var channelInstruments = [UInt8](count: 16, repeatedValue: 0)
        for(var i=0; i<events.count;i++) {
            let mevent = events[i]
            if(mevent.eventFlag == EventProgramChange){
                channelInstruments[Int(mevent.channel)] = mevent.instrument
            }
        }
        channelInstruments[9] = 128 /* Channel 9 = Percussion */

        var result = [MidiTrack]()
        for (var i = 0; i < origtrack.notes!.count; i++) {
            let note = origtrack.notes![i]
            var foundchannel = false
            for (var tracknum = 0; tracknum < 2; tracknum++) {
                let track = result[tracknum];
                let note2 = track.notes![0];
                if (note.channel == note2.channel) {
                    foundchannel = true
                    track.addNote(note)
                }
            }
            if (!foundchannel) {
                //MidiTrack* track = [[MidiTrack alloc] initWithTrack:([result count] + 1)];
                let track = MidiTrack(tracknum: result.count+1)
                track.addNote(note)
                let instrument = channelInstruments[Int(note.channel)]
                track.instrument = instrument
                result.append(track)
            }
        }
        if(origtrack.lyrics != nil)
        {
            for(var i = 0; i < origtrack.lyrics!.count;i++){
                let lyricEvent = origtrack.lyrics![i]
                for(var j = 0; j < result.count; j++) {
                    let track = result[j]
                    let note = track.notes![0]
                    if(lyricEvent.channel == note.channel){
                        track.addLyric(lyricEvent)
                    }
                }
            }
        }
        return result
    }
    
    public static func checkStartTimes(tracks:[MidiTrack]){
        for(var tracknum = 0; tracknum < tracks.count; tracknum++)
        {
            let track = tracks[tracknum]
            var prevTime = -1
            for(var j = 0; j < track.notes!.count;j++)
            {
                let note = track.notes![j]
                assert(note.startTime >= prevTime)
                prevTime = note.startTime
            }
        }
    }
    
    
    
    public func getTrackLength(inout events:[MidiEvent])->Int
    {
        var len = 0
        var buf = [u_char](count: 1024, repeatedValue: 0)
        for(var i = 0; i < events.count; i++)
        {
            let mevent:MidiEvent = events[i]
            len += varlenToBytes(mevent.deltaTime, buf: &buf, offset: 0)
            len += 1
            switch(mevent.eventFlag){
            case EventNoteOn: len += 2; break;
            case EventNoteOff:len += 2; break;
            case EventKeyPressure: len += 2; break;
            case EventControlChange: len += 2;break;
            case EventProgramChange: len += 1;break;
            case EventChannelPressure:len += 1;break;
            case EventPitchBend: len += 2;break;
                
            case SysexEvent1,SysexEvent2:
                len += varlenToBytes(mevent.metalength, buf: &buf, offset: 0)
                len += mevent.metalength
                break;
            case MetaEvent:
                len += 1
                len += varlenToBytes(mevent.metalength, buf: &buf , offset: 0)
                len += mevent.metalength
                break;
            default:
                break;
            }
        }
        return len
    }
    
//    public func writeToFile(filename:String,events:[MidiEvent],trackMode:Int,quarter:Int){
//        var buf = [u_char](count: 65536, repeatedValue: 0)
//        
//    }
    
    public func addTempoEvent( eventlist:[[MidiEvent]],tempo:Int)
    {
        for(var tracknum = 0; tracknum < eventlist.count; tracknum++)
        {
            let tempoEvent = MidiEvent()
            tempoEvent.deltaTime = 0
            tempoEvent.startTime = 0
            tempoEvent.hasEventFlag = true
            tempoEvent.eventFlag = MetaEvent
            tempoEvent.metaEvent = MetaEventTempo
            tempoEvent.metalength = 3
            tempoEvent.tempo = tempo
            
            var events = eventlist[tracknum];
            events.insert(tempoEvent, atIndex: 0)
        }
    }
    
    public func updateControlChange(var newevents:[MidiEvent], changeEvent:MidiEvent){
        for(var i = 0; i < newevents.count; i++)
        {
            let mevent = newevents[i]
            if((mevent.eventFlag == changeEvent.eventFlag) &&
                (mevent.channel == changeEvent.channel) &&
                (mevent.controlNum == changeEvent.controlNum) ){
                    mevent.controlValue = changeEvent.controlValue
                    return
            }
        }
        newevents.append(changeEvent)
    }
}