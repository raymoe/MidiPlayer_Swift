//
//  FileUtil.swift
//  MidiPlayer_Swift
//
//  Created by zhou on 16/1/17.
//  Copyright © 2016年 zhou. All rights reserved.
//

import Foundation

public class FileUtil
{
    public static func getDocumentDir()->String
    {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public static func getMidiFilePath(name:String)->String
    {
        return getDocumentDir()+"/MidiFile/"+name
    }
    
    public static func copyResourceFileToDocumentsDir(extention:String,path:String)
    {
        let mainBundle = NSBundle.mainBundle()
        let fileMgr = NSFileManager.defaultManager()
        let resPath = mainBundle.resourcePath
        let docPath = getDocumentDir()
        let desPath = docPath+"/"+path;
        do
        {
            if(!fileMgr.fileExistsAtPath(desPath))
            {
                try fileMgr.createDirectoryAtPath(desPath, withIntermediateDirectories: true, attributes: nil)
            }
            let resFiles = try fileMgr.contentsOfDirectoryAtPath(resPath!)
            for resFile:String in resFiles
            {
                //print(resFilePath)
                let resFilePath = resPath!+"/"+resFile
                if(NSString(string: resFilePath).pathExtension == "mid")
                {
                    if(!fileMgr.fileExistsAtPath(desPath+"/"+resFile))
                    {
                        try fileMgr.copyItemAtPath(resFilePath, toPath: desPath+"/"+resFile)
                    }
                }
            }
        }
        catch
        {
            print(error)
        }
        //NSString*resourcePath =[[NSBundle mainBundle] pathForResource:@"txtFile" ofType:@"mid"];
    }
}