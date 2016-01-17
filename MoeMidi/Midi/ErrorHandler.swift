//
//  ErrorHandler.swift
//  MoeMidi
//
//  Created by zhou on 15/12/2.
//  Copyright © 2015年 zhou. All rights reserved.
//

import Foundation

public class ErrorHandler{
    //private static var _errMsg : String
    public static var errMsg = ""
    
    public static func error(reason:String,offset:Int)
    {
        errMsg = "\(reason) at offset \(offset)"
    }
}