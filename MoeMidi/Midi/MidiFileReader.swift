//
//  MidiFileReader.swift
//  MoeMidi
//
//  Created by zhou on 15/11/29.
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
import Darwin





public class MidiFileReader{
    private var _data:NSData? = nil
    private var _bytes:UnsafePointer<u_char> = nil
    private var _parseOffset:Int  = 0
    private var _datalen : Int = 0
    //private var errMsg :String = ""
    public var offset : Int
    {
        return _parseOffset
    }
    
    public init(path:NSURL) throws {
        
        _data = NSData(contentsOfURL: path)
        if(_data==nil){
            ErrorHandler.errMsg = "Unable to open file \(path.path)"
            //return
            throw MidiFileError.UnableToOpenFile
        }
        else if(_data!.length==0){
            ErrorHandler.errMsg = "File is empty"
            //return
            throw MidiFileError.FileIsEmpty
        }
        _parseOffset = 0
        _datalen = _data!.length
        _bytes = UnsafePointer<u_char>(_data!.bytes)
    }
    
//    public init(filename:String){
//        //NSFileManager
//        NSData
//    }
    public func checkRead(amount:Int) throws {
        if(_parseOffset + amount > _datalen){
            ErrorHandler.errMsg  = "File is truncated"
            throw MidiFileError.FileIsTruncated
        }
    }
    
    public func peek() throws ->u_char
    {
        try checkRead(1)
        return _bytes[_parseOffset]
    }
    
    public func readByte() throws ->u_char
    {
        try checkRead(1)
        let x = _bytes[_parseOffset]
        _parseOffset++
        return x
    }
    
    public func readBytes(amount:Int) throws ->UnsafePointer<u_char>
    {
        try checkRead(amount)
        let result = (malloc(sizeof(u_char)*amount))
        _data?.getBytes(result, range: NSRange(location: _parseOffset,length: amount))
        _parseOffset += amount
        return UnsafePointer<u_char>(result)
    }
    
    public func readShort() throws -> u_short
    {
        try checkRead(2)
        let x:u_short = (u_short)((_bytes[_parseOffset] << 8) | _bytes[_parseOffset+1])
        _parseOffset += 2
        return x
    }
    
    public func readInt() throws -> Int
    {
        try checkRead(4)
        let x = (Int)((_bytes[_parseOffset]<<24) |
                          (_bytes[_parseOffset+1]<<16) |
                          (_bytes[_parseOffset+2]<<8) |
                          (_bytes[_parseOffset+3])
            )
        _parseOffset += 4
        return x
    }
    
    public func readAscii(len:Int) throws ->UnsafePointer<Int8>
    {
        try checkRead(len)
        let result = (malloc(sizeof(UInt8)*len))
        _data?.getBytes(result, range: NSRange(location: _parseOffset,length: len))
        _parseOffset += len
        return UnsafePointer<Int8>(result)
    }
    
    public func readVarlen() throws ->Int
    {
        var result:uint = 0
        var b : UInt8 =  0
        try b = readByte()
        result = (uint) (b & 0x7f)
        
        for (var i = 0; i < 3; i++) {
            if ((b & 0x80) != 0) {
                try b = readByte();
                result =  (result << 7)
                result += (uint)(b & 0x7f)
            }
            else {
                break;
            }
        }
        return Int(result);
    }
    
    public func skip(amount:Int) throws {
        try checkRead(amount)
        _parseOffset += amount
    }
    
    
}