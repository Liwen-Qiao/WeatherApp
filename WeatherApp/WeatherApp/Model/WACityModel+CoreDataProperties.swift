//
//  WACityModel+CoreDataProperties.swift
//  
//
//  Created by qiaoliwen on 2020/9/10.
//
//

import Foundation
import CoreData


extension WACityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WACityModel> {
        return NSFetchRequest<WACityModel>(entityName: "WACityModel")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var cityKey: String
    @NSManaged public var cityTem: Double
    @NSManaged public var cityConditionId: Int16
    @NSManaged public var userModel: WAUserModel?

}
