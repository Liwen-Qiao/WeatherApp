//
//  WAWeatherDetailView.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy

class WAWeatherDetailView: UIView {
    
    private var conditionImageView: UIImageView!
    private var temperatureLabel: UILabel!
    private var cityLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        cityLabel = UILabel()
        cityLabel.text = "Getting Weather Infomation..."
        cityLabel.font = WAConstant.fontNormal
        self.addSubview(cityLabel)
        cityLabel.easy.layout([Top(0),Left(0),Right(0), Height(60)])
        
        conditionImageView = UIImageView()
        conditionImageView.image = #imageLiteral(resourceName: "background")
        self.addSubview(conditionImageView)
        conditionImageView.easy.layout([Top(0).to(cityLabel),CenterX(0), Height(UIScreen.main.bounds.height/5), Width(UIScreen.main.bounds.height/5)])
        
        temperatureLabel = UILabel()
        temperatureLabel.font = WAConstant.fontTitle
        temperatureLabel.textAlignment = .center
        temperatureLabel.tintColor = UIColor(named: "weatherColor")
        self.addSubview(temperatureLabel)
        temperatureLabel.easy.layout([Top(0).to(conditionImageView),CenterX(0), Height(UIScreen.main.bounds.height/5), Width(UIScreen.main.bounds.width-40)])
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocationInfo(cityName: String, temperature: Double){
        cityLabel.text = cityName
        temperatureLabel.text = "\(String(temperature))" + "°C"
    }
}

