//
//  WAWeatherDetailMainPage.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy

class WAWeatherDetailMainPage: UIViewController{
    
    //core data
    private var coreDataStack: WACoreDataStack
    
    init(coreDataStack: WACoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Layer Adding"
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = []
        
    }
}
