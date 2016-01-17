//
//  MidiEvent.swift
//  MoeMidi
//
//  Created by zhou on 15/12/6.
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

public class MidiEvent
{
    public var deltaTime    : Int       = 0
    public var startTime    : Int       = 0
    public var hasEventFlag : Bool      = false
    public var eventFlag    : u_char    = 0
    public var channel      : u_char    = 0
    public var noteNumber   : u_char    = 0
    public var velocity     : u_char    = 0
    public var instrument   : u_char    = 0
    public var keyPressure  : u_char    = 0
    public var chanPressure : u_char    = 0
    public var controlNum   : u_char    = 0
    public var controlValue : u_char    = 0
    public var pitchBend    : u_short   = 0
    public var numerator    : u_char    = 0
    public var denominator  : u_char    = 0
    public var tempo        : Int       = 0
    public var metaEvent    : u_char    = 0
    public var metalength   : Int       = 0
    public var metavalue    : UnsafePointer<u_char> = nil
    
    public init(){
        
    }
}

