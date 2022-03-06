//
//  TimeModel.swift
//  WorldClockMVVMExample
//
//  Created by iMac on 2022/03/04.
//

import Foundation

struct TimeModel: Decodable {
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "utc_datetime"
    }
}
