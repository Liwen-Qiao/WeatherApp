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
        
        locationLbl = UILabel()
        
        locationTemLbl = UILabel()
        
        locationWeatherIconView = UIImageView()
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateLocationListCell(locationName: String, locationTem: String?, locationWeatherIcon: String?){
        locationLbl.text = locationName
        if let locationTem = locationTem, let locationWeatherIcon = locationWeatherIcon{
            locationTemLbl.text = locationTem
            locationWeatherIconView.image = #imageLiteral(resourceName: "\(locationWeatherIcon)")
        }
    }
}
