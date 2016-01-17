//
//  IntExtensions.swift
//  MoeBase
//
//  Created by zhou on 15/11/29.
//  Copyright © 2015年 zhou. All rights reserved.
//

import Foundation

//public extension Int8
//{
//    public init(rhs:Int){
//        self.value = ()
//    }
//}

public func ==(lhs: UInt8, rhs: Int) -> Bool
{
    return lhs == UInt8(rhs)
}


public extension Int
{
    public  init(rhs:UInt8){
        self = Int(rhs)
    }
    
    //@ func __converse()
}

//extension UInt8
//{
//    @conversion func __conversion<T>() -> T{
//        
//    }
//}


