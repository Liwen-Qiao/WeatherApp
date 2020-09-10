//
//  WAMainPage.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit
import EasyPeasy
import CoreData
import CoreLocation

class WAMainPage: UIViewController {
    
    var coreDataStack: WACoreDataStack!
    private weak var apiManager: WAApiManager?
    
    private var currentLocationWeatherView: WACurrentLocationView!
    private var lacationListTableView: WALocationListView!
    private var locationManager: CLLocationManager!
    
    private var userModel = WAUserModel()
    
    init(coreDataStack: WACoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
        self.apiManager = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WeFunGame"
        self.edgesForExtendedLayout = []
        setupBackgroundImage()
        setupCurrentLocationWeatherView()
        setupLocationListTableView()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func setupBackgroundImage(){
        let bgView = UIImageView()
        bgView.image = #imageLiteral(resourceName: "background")
        bgView.contentMode = .scaleAspectFill
        self.view.addSubview(bgView)
        bgView.easy.layout([Edges(0)])
    }
    
    func setupCurrentLocationWeatherView(){
        currentLocationWeatherView = WACurrentLocationView()
        currentLocationWeatherView.backgroundColor = .clear
        self.view.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.easy.layout([Top(0),Left(0),Right(0), Height(UIScreen.main.bounds.height/2)])
        
        let currentCityModel = WACityModel(cityName: "Toronto", cityKey: "55488", context: self.coreDataStack.managedContext)
        userModel.addToCityList(currentCityModel)
        coreDataStack.saveContext()
    }
    
    func setupLocationListTableView(){
        
        let addBt = UIButton()
        addBt.setImage(#imageLiteral(resourceName: "addBt"), for: .normal)
        addBt.addTarget(self, action: #selector(addBtClick), for: .touchUpInside)
        self.view.addSubview(addBt)
        addBt.easy.layout([Top(0).to(currentLocationWeatherView), Right(10), Width(40), Height(40)])
        
        lacationListTableView = WALocationListView(frame: CGRect.zero, coreDataStack: coreDataStack)
        lacationListTableView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.view.addSubview(lacationListTableView)
        lacationListTableView.easy.layout([Top(0).to(addBt),Left(0),Right(0), Height(UIScreen.main.bounds.height/2)])
        
        var cityNameList: [String] = []
        let userModelFetchRequest: NSFetchRequest<WAUserModel> = WAUserModel.fetchRequest()
        do {
            let results = try coreDataStack.managedContext.fetch(userModelFetchRequest)
           // print(results)
            guard !results.isEmpty, let cityList = results[0].cityList else {return}
            for city in cityList{
                let city = city as! WACityModel
                cityNameList.append(city.cityName ?? "")
            }
            lacationListTableView.updateCityNameList(cityNameList: cityNameList)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @objc func addBtClick(){
        
    }
}

extension WAMainPage: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("locations/v1/cities/geoposition/search.json", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("\(lat),\(lon)", forKey: "q")
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getCurrentLocation")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WAMainPage: WAApiManager{
    func doActionAfterHttp(httpResult: Any, httpTag: String) {
        var cityName: String = ""
        var cityKey: String = ""
        if httpTag == "getCurrentLocation"{
            let httpResultData = httpResult as? [String: Any] ?? [:]
            let parentCity = httpResultData["ParentCity"] as? [String: Any] ?? [:]
            print("parentCity:\(parentCity)")
            cityName = parentCity["EnglishName"] as? String ?? ""
            cityKey = parentCity["Key"] as? String ?? ""
            print(cityName)
            var httpRequest: [String: String] = [:]
            httpRequest.updateValue("get", forKey: "httpMethod")
            httpRequest.updateValue("currentconditions/v1/\(cityKey)", forKey: "httpSubUrl")
            var urlParams: [String: String] = [:]
            urlParams.updateValue("8jqwJ6zNPy3II2I2mZEXenPlOVf7PBXS", forKey: "apikey")
            self.apiManager?.httpRequestAction(httpRequest: httpRequest, bodyParams: nil, urlParams: urlParams, httpTag: "getCurrentLocationWeather")
        }else if httpTag == "getCurrentLocationWeather"{
            let httpResultData = httpResult as? [[String: Any]] ?? []
            let temperatureData = httpResultData[0]["Temperature"] as? [String: Any] ?? [:]
            let metricData = temperatureData["Metric"] as? [String: Any] ?? [:]
            let value = metricData["Value"] as? Double ?? 0
           
            self.currentLocationWeatherView.updateLocationInfo(cityName: cityName, temperature: value)
            //if cityName != ""{
                let currentCityModel = WACityModel(cityName: "Toronto", cityKey: cityKey, context: self.coreDataStack.managedContext)
                userModel.addToCityList(currentCityModel)
                coreDataStack.saveContext()
            //}
        }else{}
    }
}



//print("httpResult:\(httpResult)")
//            let httpResultData = httpResult["DailyForecasts"]
//            print("httpResultDataQI:\(httpResultData)")
//           if let data = httpResult["DailyForecasts"] as? [[String:Any]], !data.isEmpty,
//              let dayWeather = data[0]["Day"] as? [String:Any] {
//                 print("httpResultData:\(httpResultData)")
//           }
//                let dayData = httpResultData["Day"] as? [String: Any] ?? [:]
//                print("dayData:\(dayData)")
//                let nightData = httpResultData["Night"] as? [String: Any] ?? [:]
//                print("nightData:\(nightData)")
            
