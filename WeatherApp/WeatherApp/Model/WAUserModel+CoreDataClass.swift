//
//  WAUserModel+CoreDataClass.swift
//  
//
//  Created by qiaoliwen on 2020/9/10.
//
//

import Foundation
import CoreData

@objc(WAUserModel)
public class WAUserModel: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context: NSManagedObjectContext) {
        let userModelEntity = NSEntityDescription.entity(forEntityName: "WAUserModel", in: context)!
        super.init (entity: userModelEntity, insertInto: context)
       
        self.userId = UUID().uuidString
    }
}
