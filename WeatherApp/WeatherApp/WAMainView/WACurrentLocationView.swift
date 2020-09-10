//
//  WACurrentLocationView.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy

class WACurrentLocationView: UIView {
    
    private var currentLocationWeatherView: WAWeatherDetailView!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        currentLocationWeatherView = WAWeatherDetailView()
        self.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.easy.layout([Top(0), CenterX(0)])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocationInfo(cityName: String, temperature: Double){
        currentLocationWeatherView.updateLocationInfo(cityName: cityName, temperature: temperature)
    }
}

