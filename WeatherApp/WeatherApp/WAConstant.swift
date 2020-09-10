//
//  WAConstant.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit

struct WAConstant {
    static let BASE_URL = "http://dataservice.accuweather.com/"
    
    static let fontTitle = UIFont.systemFont(ofSize: 80)
    static let fontNormal = UIFont.systemFont(ofSize: 30)
    static let fontSmall = UIFont.systemFont(ofSize: 16)
    
    static func getConditionName(conditionId: Int16) -> String{
        switch conditionId {
        case 12...18:
            return "cloud.drizzle"
        case 24...29:
            return "cloud.rain"
        case 19...23:
            return "cloud.snow"
        case 6...11:
            return "cloud.fog"
        case 1...5:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
