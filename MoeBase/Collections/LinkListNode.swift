//
//  LinkListNode.swift
//  MidiPlayer_Swift
//
//  Created by zhou on 15/11/28.
//  Copyright © 2015年 zhou. All rights reserved.
//

import Foundation

public class LinkListNode<T>
{
    private var _linkList : LinkList<T>?
    private var _next : LinkListNode<T>?
    private var _previous : LinkListNode<T>?
    private var _value : T
    public var list : LinkList<T>? {
        return _linkList;
    }
    public var next : LinkListNode<T>?{
        return _next
    }
    public var previous : LinkListNode<T>?{
        return _previous
    }
    public var value : T{
        return _value
    }
    
    public init(v:T){
        _value = v
    }
    
    
    
}