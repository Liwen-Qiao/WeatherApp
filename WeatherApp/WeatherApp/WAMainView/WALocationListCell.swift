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
        locationTemLbl.easy.layout([Right(20),CenterY(0), Height(60), Width(80)])
        
        locationWeatherIconView = UIImageView()
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateLocationNameList(locationName: String){
        locationLbl.text = locationName
    }
    
    func updateLocationListCell(locationTem: String, locationWeatherIcon: String){
        locationTemLbl.text = locationTem
        locationWeatherIconView.image = UIImage(systemName: locationWeatherIcon)
    }
}
