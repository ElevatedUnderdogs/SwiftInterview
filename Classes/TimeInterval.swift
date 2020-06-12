//
//  TimeInterval.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    var timeString: String {
        let minutes = Int(self) / 60 % 60,
        seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
