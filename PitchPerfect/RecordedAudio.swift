//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Michael Stockman on 10/6/15.
//  Copyright © 2015 Michael Stockman. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(url :NSURL, name :String) {
        super.init()
        filePathUrl = url
        title = name
    }
}