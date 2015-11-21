//
//  MidiTrack.swift
//  MidiPlayer
//
//  Created by zhou on 15/11/21.
//  Copyright (c) 2015年 zhou. All rights reserved.
//

import Foundation

public class LyricSymbol
{
    private var _startTime:Int = 0
    //private var _tex
    public var startTime:Int = 0
    public var text:String = ""
    public var x:Int = 0
    public var minWidth:Int
    {
        get{
            return 0;
        }
    }
    
    public init()
    {
        
    }
}

public class MidiTrack : NSObject,NSCopying
{
    var  number:Int = 0
    var  instrument:Int = 0
    
    public init(tracknum:Int) {
        
    }
    
    public  func copyWithZone(zone: NSZone) -> AnyObject {
        return ""
    }
}