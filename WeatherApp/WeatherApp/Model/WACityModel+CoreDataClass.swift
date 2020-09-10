//
//  WACityModel+CoreDataClass.swift
//  
//
//  Created by qiaoliwen on 2020/9/10.
//
//

import Foundation
import CoreData

@objc(WACityModel)
public class WACityModel: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(cityName: String, cityKey: String, context: NSManagedObjectContext) {
        
        let cityModelEntity = NSEntityDescription.entity(forEntityName: "WACityModel", in: context)!
        
        super.init(entity: cityModelEntity, insertInto: context)
       
        self.cityName = cityName
        self.cityKey = cityKey
    }
}
