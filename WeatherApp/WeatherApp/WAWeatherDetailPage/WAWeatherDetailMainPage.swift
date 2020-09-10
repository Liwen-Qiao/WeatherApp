////
////  WAWeatherDetailMainPage.swift
////  WeatherApp
////
////  Created by qiaoliwen on 2020/9/10.
////  Copyright © 2020 qiaoliwen. All rights reserved.
////
//
//import UIKit
//import EasyPeasy
//
//class WAWeatherDetailMainPage: UIViewController{
//    
//    //core data
//    private var coreDataStack: WACoreDataStack
//    //api
//    private weak var apiManager: WAApiManager?
//    //
//    private var weatherDetailView: WAWeatherDetailView!
//    
//    init(cityModel: WACityModel, coreDataStack: WACoreDataStack) {
//        self.coreDataStack = coreDataStack
//        super.init(nibName: nil, bundle: nil)
//        self.apiManager = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = []
//        
//        let bgView = UIImageView()
//        bgView.image = #imageLiteral(resourceName: "background")
//        bgView.contentMode = .scaleAspectFill
//        self.view.addSubview(bgView)
//        bgView.easy.layout([Edges(0)])
//        
//        weatherDetailView = WAWeatherDetailView()
//        self.view.addSubview(weatherDetailView)
//        weatherDetailView.easy.layout([Top(0),Bottom(0), CenterX(0),Width(UIScreen.main.bounds.width)])
//    }
//    
//    func updateLocationInfo(cityName: String, temperature: Double, conditionName: String){
//        weatherDetailView.updateLocationInfo(cityName: cityName, temperature: temperature, conditionName: conditionName)
//    }
//    
//}
