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
    
    init(cityName: String, cityKey: String, cityTem: Double, cityConditionId: Int16, context: NSManagedObjectContext) {
        
        let cityModelEntity = NSEntityDescription.entity(forEntityName: "WACityModel", in: context)!
        
        super.init(entity: cityModelEntity, insertInto: context)
       
        self.cityName = cityName
        self.cityKey = cityKey
        self.cityTem = cityTem
        self.cityConditionId = cityConditionId
    }
    
    
    static func updateCityInfo(cityModel: WACityModel, cityTem: Double, cityConditionId: Int){
        cityModel.cityTem = cityTem
        cityModel.cityConditionId = Int16(cityConditionId)
    }
}
