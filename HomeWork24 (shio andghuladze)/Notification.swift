//
//  Notification.swift
//  HomeWork24 (shio andghuladze)
//
//  Created by shio andghuladze on 27.08.22.
//

import Foundation


struct Notification{
    let id: String = UUID().uuidString
    let title: String
    let body: String
}

enum TimeInterval: Double{
    case Second = 1
    case Minute = 60
    case Hour = 3600
    case Day = 86400
}
