//
//  WAUserModel+CoreDataProperties.swift
//  
//
//  Created by qiaoliwen on 2020/9/10.
//
//

import Foundation
import CoreData


extension WAUserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WAUserModel> {
        return NSFetchRequest<WAUserModel>(entityName: "WAUserModel")
    }

    @NSManaged public var userId: String
    @NSManaged public var cityList: NSOrderedSet?

}

// MARK: Generated accessors for cityList
extension WAUserModel {

    @objc(insertObject:inCityListAtIndex:)
    @NSManaged public func insertIntoCityList(_ value: WACityModel, at idx: Int)

    @objc(removeObjectFromCityListAtIndex:)
    @NSManaged public func removeFromCityList(at idx: Int)

    @objc(insertCityList:atIndexes:)
    @NSManaged public func insertIntoCityList(_ values: [WACityModel], at indexes: NSIndexSet)

    @objc(removeCityListAtIndexes:)
    @NSManaged public func removeFromCityList(at indexes: NSIndexSet)

    @objc(replaceObjectInCityListAtIndex:withObject:)
    @NSManaged public func replaceCityList(at idx: Int, with value: WACityModel)

    @objc(replaceCityListAtIndexes:withCityList:)
    @NSManaged public func replaceCityList(at indexes: NSIndexSet, with values: [WACityModel])

    @objc(addCityListObject:)
    @NSManaged public func addToCityList(_ value: WACityModel)

    @objc(removeCityListObject:)
    @NSManaged public func removeFromCityList(_ value: WACityModel)

    @objc(addCityList:)
    @NSManaged public func addToCityList(_ values: NSOrderedSet)

    @objc(removeCityList:)
    @NSManaged public func removeFromCityList(_ values: NSOrderedSet)

}
