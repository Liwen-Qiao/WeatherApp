//
//  WALocationListCell.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import EasyPeasy
import UIKit

class WALocationListCell: UITableViewCell {
    
    private var locationLbl: UILabel!
    private var locationTemLbl: UILabel!
    private var locationWeatherIconView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        locationLbl = UILabel()
        locationLbl.font = WAConstant.fontNormal
        locationLbl.textAlignment = .left
        locationLbl.tintColor = UIColor(named: "weatherColor")
        self.addSubview(locationLbl)
        locationLbl.easy.layout([Left(20),CenterY(0), Height(60), Width(UIScreen.main.bounds.width/2)])
        
        locationTemLbl = UILabel()
        locationTemLbl.font = WAConstant.fontNormal
        locationTemLbl.textAlignment = .left
        locationTemLbl.tintColor = UIColor(named: "weatherColor")
        self.addSubview(locationTemLbl)
        locationTemLbl.easy.layout([Right(20),CenterY(0), Height(60), Width(100)])
        
        locationWeatherIconView = UIImageView()
        locationWeatherIconView.tintColor = UIColor(named: "weatherColor")
        self.addSubview(locationWeatherIconView)
        locationWeatherIconView.easy.layout([Right(10).to(locationTemLbl),CenterY(0), Height(40), Width(40)])
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateLocationListCell(locationName: String, locationTem: Double, locationWeatherIcon: String){
        locationLbl.text = locationName
        locationTemLbl.text = String(locationTem) + "°C"
        locationWeatherIconView.image = UIImage(systemName: locationWeatherIcon)
    }
}
